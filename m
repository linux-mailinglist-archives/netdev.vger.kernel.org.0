Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E602024FE
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgFTP7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:59:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61132 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbgFTP7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:59:33 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05KFuGmm020259;
        Sat, 20 Jun 2020 08:58:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=z+Xh/usf6KewhNxpD2jOJGvDAgmX3ZWJ0CEIT2/RRpw=;
 b=gPVdd4aiRf0yl3hjPESg7jKToQSRq+j7RC6NJNoFoPIpg5HzJOUpGUbKB1J31dDoxV/U
 fpr37sHyMkNguma2HiwajuVteLMPpOPv/CMnXDcRH51czScygz7i4x2JoVEykRx5OzTg
 dGjPzPkggWYPzdUf6njg1Bk6dmclq3Meryk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31sg5b8uwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 20 Jun 2020 08:58:11 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 20 Jun 2020 08:58:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hx4pxNtxUNwa0sH1neJfsARoNCYdtY0ImY/BTp9HeMMEctBSix40nwzFiKgJsK4uSzUNU6eQX87nBUFmdnQ7tp55wLM8yro3TVHD1bq+YbrOnqxD/UR1IEBqjFbMQHONR9e9CyHmxDDiejqyYQz4rt7ptYNhPF+JAuKLhKAXVMf4fN8EY6Tj2PPegcBhwjvGabQInpGUFeCB8hB4pwkRm6az6FYTiCZ+E4Zyy7yYBAwigIH7wbALxc34KLbZ19nnOBP2t6HdPXbWFHTbF6ePpYqcoIwrnjj9AHCm7IeO8wjnGnKzOFFSzgzLdVZkyw9TQIxz5qYFdlx3paw0fRGhRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+Xh/usf6KewhNxpD2jOJGvDAgmX3ZWJ0CEIT2/RRpw=;
 b=iyczABTyxcWCOixLrtutASphxozHFwJJP3NcjzFpCXprFmwgbJRJLm5jJV3J0IAPlV+9dowT2/aGl5Hh79Aeo2ROBZRX9HxUCK+iHuDYL79j1mwwqbv9+2t853/bkjVAqw5mgfTbgzrj3VzWCqeO2KMuC/hfL574mlz7OtjaXhFtTNUdw4OGlVAc5dHp5z+Xpkbo6T4qR13ztssT0I93D9n8gxt8Ts7pGOxVhw1jgmHYto4xNsfZp5y0CGZ+RQ3BJRgMKm6mVk5Dx1I3wsRL5ccTfdp4MTBjQcKhMQQDHKNSiUCMGO5maHF4nHRsVQs482pB539w0GqKQm+zAtaBlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+Xh/usf6KewhNxpD2jOJGvDAgmX3ZWJ0CEIT2/RRpw=;
 b=DMFOB9vCIxmoqB6fqy8Gefi9CdxOuFI7PYybzs0x8I5ZgHT2brRdjMIlg5f0sy6FYfmhFAvr1ikigTzPIyaaQqTRg+5pc9fC65SHx2ftYxfhaxxeHNViRvfC7wRK62duAqCF2WsQTUO1nsF9GvZ4fuBFFKbGHArbdDofisdKDMg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2341.namprd15.prod.outlook.com (2603:10b6:a02:81::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Sat, 20 Jun
 2020 15:57:55 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3109.021; Sat, 20 Jun 2020
 15:57:55 +0000
Date:   Sat, 20 Jun 2020 08:57:51 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?iso-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
Message-ID: <20200620155751.GJ237539@carbon.dhcp.thefacebook.com>
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
 <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <20200620005115.GE237539@carbon.dhcp.thefacebook.com>
 <f80878fe-bf2d-605a-50e4-bda97a1390c2@huawei.com>
 <20200620011409.GG237539@carbon.dhcp.thefacebook.com>
 <CAM_iQpUmajKqeYW9uwtEiFeZGz=q7DFYQT5sq_27yaqoudewuQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUmajKqeYW9uwtEiFeZGz=q7DFYQT5sq_27yaqoudewuQ@mail.gmail.com>
X-ClientProxiedBy: BYAPR11CA0039.namprd11.prod.outlook.com
 (2603:10b6:a03:80::16) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:c714) by BYAPR11CA0039.namprd11.prod.outlook.com (2603:10b6:a03:80::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Sat, 20 Jun 2020 15:57:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:c714]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18fd06f5-3550-4c37-4f9f-08d81532b185
X-MS-TrafficTypeDiagnostic: BYAPR15MB2341:
X-Microsoft-Antispam-PRVS: <BYAPR15MB23414DDE303F50B9B8618C92BE990@BYAPR15MB2341.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0440AC9990
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PC5jBifJmXY/OECXsuPUG6Hx9M81EYRzab+GnirihfOchd1f1wj/jSzPcnTgllD9hn1b/f9d2sU9tVjFcRLls2kRjB+c6AjFZfX9TBXEdZAi9rkMQ0eNln/hje3HYQsHQIoCNW7tw4NUKeWWtIlJ0c626T/W0fTV+8WDhbvdWgLVQx7tqPtgfKyniwQ+ZPqHhhiKZyS0idGwVuBDqVsJ+vP+hpGP70IrG1T3AbGkgI/IjXBNEulkOYXjFt6Dn96iGTh9ORMTMwwsOGZ5TcXobGTAzX+YmCtva0G5404dFAfcPex1fqzESBmZ2yNMEYSpJGuMAClBVD/Flfc407nvqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(136003)(346002)(366004)(376002)(66946007)(5660300002)(66476007)(66556008)(8936002)(52116002)(6916009)(1076003)(316002)(7696005)(4326008)(33656002)(83380400001)(16526019)(53546011)(6506007)(9686003)(186003)(2906002)(8676002)(478600001)(55016002)(86362001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Ga3L6Xdqqoyi1dAhbuOYd8zOuoTrAgbCh7x3tcUvpRC2LxyioJnmpwWQzLQwZkyx4gIm8vCS+va9Y0xKUZFGPXybDysCkVndCXrJs/hPLdb1yVC+EPkG+izMOQjLXQzZSIy56raTHJXnA7pYZFw/YD0EKDg9aIvDOkghHTqqxHIhWXKCPKgEo0Yo6c7EeSq1NjiXmDbj+iPDzgHHPoM6KxqzQAJC4AlAH8Kl49Ad2GyB8hOPnhgGIqA3bD6JmauGKd2mN/sOAYJo7U8Cwz/Rj3dr9OZ5U61yZW1vUXHgbt3OioAYQXMgZTYL2bQyF6ONlGeFym52BoBafNZbdnu0B1crn7BWa/XsON/yCczK+GqznJP1qeIjsJRVoxrdiKa7hUz0X9AyTp4APRwjeDWF4EtPZSPujNRRHmA/HY+BQc0qq7CRWOeQ3/H7uOcN3V5wUV0242HM6/6P/vDg0q9N+tJFBgwU77BqP+QGTTzhqjG4btDXsJV/oruGH0/fpX6+4Y0m/YLxOtEx0UCfP1g4vA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 18fd06f5-3550-4c37-4f9f-08d81532b185
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2020 15:57:55.1078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TN9DPEjCzhb+J7XJn5sijJjnbSQ8NRes4yCjVGIFkmOSJp2smbQE/FBdawZMgvqc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2341
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-20_09:2020-06-19,2020-06-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 mlxlogscore=852 cotscore=-2147483648 suspectscore=1 spamscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006200118
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 08:00:41PM -0700, Cong Wang wrote:
> On Fri, Jun 19, 2020 at 6:14 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Sat, Jun 20, 2020 at 09:00:40AM +0800, Zefan Li wrote:
> > > I think so, though I'm not familiar with the bfp cgroup code.
> > >
> > > > If so, we might wanna fix it in a different way,
> > > > just checking if (!(css->flags & CSS_NO_REF)) in cgroup_bpf_put()
> > > > like in cgroup_put(). It feels more reliable to me.
> > > >
> > >
> > > Yeah I also have this idea in my mind.
> >
> > I wonder if the following patch will fix the issue?
> 
> Interesting, AFAIU, this refcnt is for bpf programs attached
> to the cgroup. By this suggestion, do you mean the root
> cgroup does not need to refcnt the bpf programs attached
> to it? This seems odd, as I don't see how root is different
> from others in terms of bpf programs which can be attached
> and detached in the same way.
> 
> I certainly understand the root cgroup is never gone, but this
> does not mean the bpf programs attached to it too.
> 
> What am I missing?

It's different because the root cgroup can't be deleted.

All this reference counting is required to automatically detach bpf programs
from a _deleted_ cgroup (look at cgroup_bpf_offline()). It's required
because a cgroup can be in dying state for a long time being pinned by a
pagecache page, for example. Only a user can detach a bpf program from
an existing cgroup.

Thanks!

