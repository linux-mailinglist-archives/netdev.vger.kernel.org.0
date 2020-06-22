Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EE920420B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 22:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgFVUkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 16:40:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbgFVUkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 16:40:36 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MKV0vl023353;
        Mon, 22 Jun 2020 13:39:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=JOaRidfnQmV+ZQ4uE2D4NCKYwpuaZDZEy9tGiD8xKkI=;
 b=FmiqtNeezWmg2j5+BWUdtWDu6Aw4fAKrFv58YEK8G77hIi1b7LAZFIBZBaEzjYAM6bZc
 4SlYnpNBJNX7g3gQgvUry2VH6sttOarGBtg2GjkZ72FOVyL5aQL+9rw+YZ+1j3ftbG9U
 tUMbMirXO73zoJfiw9Itqhz1AM+mIjV335I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31t25bqgmp-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 22 Jun 2020 13:39:27 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Jun 2020 13:39:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYBu9sAQOlxE6yZc27Iuocr/Fl+iHrEquaack3V3JCwx99Ip5Ltn32WfGnAxNz2BV+peYZ3Do9uV3Yj26HEgWCY8snP1p2VUwGIAMie47VIzm3EbSBTvzQlz10Mka2wywE84UnlMUksWqZxwnJVBezjeBg0I1OooHomUAVC5/uI0sIPFvKPgzVjlJYK/g3aHxOFR5NKMtqiVVVZEfeA92lH0xwrodpyJ3obeUtK3Ow99BY0hjPudjYt8YrfGTiff9OyY7C01sNTzqIjRM3q9M45PiMb2N9o518ORkRk12oNdG9U0zzyLwi3anWipnRZEKYlzK6DB2GbRIBPDgtzlDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOaRidfnQmV+ZQ4uE2D4NCKYwpuaZDZEy9tGiD8xKkI=;
 b=K5VANT5Gnz796GtDrye2UY/nd7Q7/BUxw/g/MatOzbEY1xxPvyT5GxjEnl5BIDej6gtbKG5/+tcpSGeGoG+OqJZpIu1nFstN4njFK6wpny96dMhYUehyjZTpTN2Vus9Pv9n5TwSaZHNmGvEkFjzj5JCRf+KxHfVC4uwqop5kGth9ChJNqPHf1beYRVwNl4vFsK+p5nt/kgTs3zh4IEWwpSmvtCKxW6zdR9mf7jdQ+03vz8YazbYZhkBgKS6bkJ2E8eOfrYqNsFczuPvmO6kUjIY1HjjN5v7Z/HfZjSLtGb9o0UwR+HgRAjld8kj0xnMEASVC5N4huJDRngJSqFg8uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOaRidfnQmV+ZQ4uE2D4NCKYwpuaZDZEy9tGiD8xKkI=;
 b=QQNgrASR/6VDI5h+Bpbs6sEqEOC/uaJMMpXlQgyrmQjAVXuJHVd08JdG+W0QDbc62ZqhdpYOrB3ei5sV0HtfK1Sggi1QVZsE0lZSe7EoNCDIvy+S2i8LQ0OJaVI8Cw2/E4H6FPhgIb8U529Uz9Ca3tT0Mt/jZOZwLrEyHadjTiA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3144.namprd15.prod.outlook.com (2603:10b6:a03:fe::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 20:39:14 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 20:39:14 +0000
Date:   Mon, 22 Jun 2020 13:39:10 -0700
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
Message-ID: <20200622203910.GE301338@carbon.dhcp.thefacebook.com>
References: <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <20200620005115.GE237539@carbon.dhcp.thefacebook.com>
 <f80878fe-bf2d-605a-50e4-bda97a1390c2@huawei.com>
 <20200620011409.GG237539@carbon.dhcp.thefacebook.com>
 <CAM_iQpUmajKqeYW9uwtEiFeZGz=q7DFYQT5sq_27yaqoudewuQ@mail.gmail.com>
 <20200620155751.GJ237539@carbon.dhcp.thefacebook.com>
 <CAM_iQpVTwkxep3RCcwqCE0rypwj5prLdbE4oEUTyev+RxQq37Q@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVTwkxep3RCcwqCE0rypwj5prLdbE4oEUTyev+RxQq37Q@mail.gmail.com>
X-ClientProxiedBy: BY3PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:a03:217::32) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:c7f8) by BY3PR04CA0027.namprd04.prod.outlook.com (2603:10b6:a03:217::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Mon, 22 Jun 2020 20:39:13 +0000
X-Originating-IP: [2620:10d:c090:400::5:c7f8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f87e524a-c593-48c6-26c3-08d816ec5345
X-MS-TrafficTypeDiagnostic: BYAPR15MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3144ED354B70A407F704F653BE970@BYAPR15MB3144.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DOfKUZ0MiB6Jsq1K0COXVM+yD9xCuC72BLYdNLou6Sw4HxwDF//nW91HLzn2zz3DTbtPfvFVE2F3qAMshV0RbOl6ZTqB5VKJURZxwHGgQg3/0YrDjsTT9iRBC/npnvEC2nDAK16SXLG/8n9plMBuU23GS1NI/0Kjpq3bp6UhwSxgYpXEiM9uiR7fTZIHLz6NDagM3UHe+s0uhjUoGq11+FIRyZ5hqkfOYQIodJUpbaEwZ4bsSaxI4HFpcIxldg/mscrrsfiBP11pLKdNETpo8D/i36+I+Z37+QDkE9ESDCODs54IwiBC3u3zCb+YsJA5zKigXnauONsmRAFY9Q1gXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(39860400002)(346002)(396003)(376002)(66476007)(53546011)(7696005)(52116002)(66556008)(8936002)(9686003)(66946007)(55016002)(6916009)(16526019)(83380400001)(1076003)(316002)(8676002)(6506007)(2906002)(186003)(33656002)(5660300002)(54906003)(4326008)(86362001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: GEWAXv9kvEcJ+NSgTMY3/4XbA1FVUDnCiFXdGPFCY0PbzeWlbXNAzQTVscZSd3BPJCOWDhTt4DFaIOFaZFYyVTbTjIMr5fJ2I+q5r6fx3dPh+GKvLLZLzj8F6ZgYcKiTkKLWee0kKBiMKjWA6sjfRoGi9rx8hT/1eceGyh3vjNQLt6YYfTu0sAp5S81FEyviW5jwMmbPTs8aqPZMHAz9/up0fApGvRmVrhxO+AiHwzRGBQJy9z1ZFNcYhxAeyyC7VWigzRWVxKWIM9mTLZzncz17RwBJXWbDdMIF7DcsAfSXjOLDMLO8whqFL2E9l4uePkVSs0qE9VVu7B786vYVxyhALRKFCgPBGOuuUmtto6e333p44PQlFayrCmRFrNdlW/gqmrtQ0hH7RWXSxi/lrmec8Qw1pKdKaLlaD9fpxifE635p87xAhJbe/trvDoDKNbrgwMsVLylIRVvfuT+JrL7PFIyZ6YofHh9vLQfCda9jt9lelhlWSAj8grmEriUaUCTCfr8Y5FCzyhafZ64UJA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f87e524a-c593-48c6-26c3-08d816ec5345
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 20:39:13.9910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e44UwrVJNwjc7YUcj0sm2wKOVlDuCq5EifJOLeZGNkvjBiypOp7VvjRGEj5JcJeH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3144
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_12:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 impostorscore=0 cotscore=-2147483648 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 adultscore=0 suspectscore=1
 mlxscore=0 malwarescore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220134
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 11:14:20AM -0700, Cong Wang wrote:
> On Sat, Jun 20, 2020 at 8:58 AM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Fri, Jun 19, 2020 at 08:00:41PM -0700, Cong Wang wrote:
> > > On Fri, Jun 19, 2020 at 6:14 PM Roman Gushchin <guro@fb.com> wrote:
> > > >
> > > > On Sat, Jun 20, 2020 at 09:00:40AM +0800, Zefan Li wrote:
> > > > > I think so, though I'm not familiar with the bfp cgroup code.
> > > > >
> > > > > > If so, we might wanna fix it in a different way,
> > > > > > just checking if (!(css->flags & CSS_NO_REF)) in cgroup_bpf_put()
> > > > > > like in cgroup_put(). It feels more reliable to me.
> > > > > >
> > > > >
> > > > > Yeah I also have this idea in my mind.
> > > >
> > > > I wonder if the following patch will fix the issue?
> > >
> > > Interesting, AFAIU, this refcnt is for bpf programs attached
> > > to the cgroup. By this suggestion, do you mean the root
> > > cgroup does not need to refcnt the bpf programs attached
> > > to it? This seems odd, as I don't see how root is different
> > > from others in terms of bpf programs which can be attached
> > > and detached in the same way.
> > >
> > > I certainly understand the root cgroup is never gone, but this
> > > does not mean the bpf programs attached to it too.
> > >
> > > What am I missing?
> >
> > It's different because the root cgroup can't be deleted.
> >
> > All this reference counting is required to automatically detach bpf programs
> > from a _deleted_ cgroup (look at cgroup_bpf_offline()). It's required
> > because a cgroup can be in dying state for a long time being pinned by a
> > pagecache page, for example. Only a user can detach a bpf program from
> > an existing cgroup.
> 
> Yeah, but users can still detach the bpf programs from root cgroup.
> IIUC, after detaching, the pointer in the bpf array will be empty_prog_array
> which is just an array of NULL. Then __cgroup_bpf_run_filter_skb() will
> deref it without checking NULL (as check_non_null == false).
> 
> This matches the 0000000000000010 pointer seen in the bug reports,
> the 0x10, that is 16, is the offset of items[] in struct bpf_prog_array.
> So looks like we have to add a NULL check there regardless of refcnt.
> 
> Also, I am not sure whether your suggested patch makes a difference
> for percpu refcnt, as percpu_ref_put() will never call ->release() until
> percpu_ref_kill(), which is never called on root cgroup?

Hm, true. But it means that the problem is not with the root cgroup's bpf?

How easy is to reproduce the problem? Is it possible to bisect the problematic
commit?

Thanks!
