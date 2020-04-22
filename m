Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB991B50EF
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 01:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgDVXkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 19:40:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32882 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbgDVXkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 19:40:41 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03MNeKsM008818;
        Wed, 22 Apr 2020 16:40:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=B43E7k/FCJbc1e2VheqY3qZ7DNS6yOxVxu9jtVVRs48=;
 b=b7gWNncsnnHm2pj37vRK/BxoyiM4yZGxvouAt6+X+Yjos4uh6OW4I0iqHzfNzC1jDBHU
 bX6tAjHQr7bnNmbHwNMoE3diDNgdLPcZd/mzC7cirafbM1v486OuWdWGgxE556QUtxNv
 M0j27MWgWbs63X5QvfDL4slyJmoo6h/Uyis= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30ghjpvcbm-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Apr 2020 16:40:21 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 22 Apr 2020 16:40:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1zw/lR1C7g9Y20V/7WSvh9XohR1TkkKvxE538w+SO7Oo6bzEZE4wta7vfP4loZBZ6Nx7bHh5qsgg13YMdhVrf1Q38f2OSz4g9tN4vQl36rYXFnHVNoLgwI7TR8s/G6ttPyd6O+tP33SRD/hDpycBhsFFPeByWH3sPHWWZhPsge0GN5y4JvGFZrvi81Cgvcqh7kJat9fVVaUoPNkf3BrA8iKkvvxDgLEvOjJhHWNpbnMbgfQPD3Oq8ztpdj9QI0VQZI8MGBVvcQfQTN5TUrqeG7jwnvZF+eUd1gjNA2Ec4keBDWUWkdJEh+z+IDPpkmOMmb2KuuPPUnlXOZpQN9uYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B43E7k/FCJbc1e2VheqY3qZ7DNS6yOxVxu9jtVVRs48=;
 b=mqvhaAN2dDP84oU9yNif16ylymR20BdQqxGpNJ3vLKc2Hc3DB9M37xLyBNSAnZBQidgeMA3FANsd1IHqIw1aDss39+VXOAEofioTMdyui92z2UnK2hExWRmjJsHizO1P9E58lA80UVEVxpug9twsYwiYZNM/I3SL9uJPdr/HlI1EZGiFYL4mfzfecf0kUKvzgdZrJyXKkEpcfKEeiIt28cNpsBNMSsqHAfZBJJ70qwY00F/Mxh6pLSTwX57sOawJzsLV//B0BUujUxLcs8QbVakxGMewCDMMv5TOk81SeY8HRPmyv/++10GF0P+4yV+40qLHf3ZfGaMruZP0IBxxfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B43E7k/FCJbc1e2VheqY3qZ7DNS6yOxVxu9jtVVRs48=;
 b=ZGK2j1VussxKtyigN0kbsq3Ogp1mR828QMOrc1WVuiCZrAmxUk4PE5pr6wluD8pS53rcG6ZMp+TvezZeQ38a0A7uuH6dDSreQ5ORrLc0hFhDaNDc3sIL65Jg2RwVNY5fZoChrKJhzKqBKjbxqVlj9gYoPBkGJrankAvXffBHEXY=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB3301.namprd15.prod.outlook.com (2603:10b6:a03:101::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Wed, 22 Apr
 2020 23:40:09 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 23:40:09 +0000
Date:   Wed, 22 Apr 2020 16:40:06 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH 5/5] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <20200422234006.GB6764@rdna-mbp.dhcp.thefacebook.com>
References: <20200421171539.288622-1-hch@lst.de>
 <20200421171539.288622-6-hch@lst.de>
 <20200421192330.GA60879@rdna-mbp.dhcp.thefacebook.com>
 <20200422172254.GA30102@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200422172254.GA30102@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: CO1PR15CA0064.namprd15.prod.outlook.com
 (2603:10b6:101:1f::32) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:1d4c) by CO1PR15CA0064.namprd15.prod.outlook.com (2603:10b6:101:1f::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 23:40:08 +0000
X-Originating-IP: [2620:10d:c090:400::5:1d4c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a2905c4-6400-47ce-10b4-08d7e7167e2e
X-MS-TrafficTypeDiagnostic: BYAPR15MB3301:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3301CD24A6134E195668AB13A8D20@BYAPR15MB3301.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(39860400002)(396003)(136003)(376002)(346002)(8676002)(4744005)(2906002)(4326008)(316002)(52116002)(81156014)(7416002)(9686003)(6486002)(86362001)(54906003)(478600001)(186003)(6496006)(16526019)(1076003)(6916009)(66946007)(8936002)(5660300002)(66476007)(33656002)(66556008);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zDj16FjdrmPhWxAo7//JMl43AKSs4pwDhjj6+sAUFm/YaCE3p7hpwj2EnJEImHyMEmOf/UXvOuMs6AnQO1qe2ECSQ4r8xwSu2xaXB604Oix9qV3+YxEyVZA4RZIIGBft8do3LnTPFL3UXH9NJxCrl0JvKVPBwjv4iYfvWtr+04cntaWUNOWz7j1lTTRqAlYlHE/Q4+72/bkWkQ2+cJdy0Ae6NXPt188WQ2hvDxce23+Kubg7b9cLQ+wbvKFLQAMUBnG+OAkhIsMo7ep7J7Dgv2JWrudd/PYq8awxeZi1aA44GuVraJM9HHolmdSKLdkz4vfGFwli3zm0bFVZUzhCcMGUreqvuPSkfm1/WufMok/Eg/H/SJT477yNJUkwzFF3ZneEzkHZWwRvV7RNNLwonU3uCnNvlJbCDMyxXLpLfUnFSLnN7sDCl3q8O8rlyDuZ
X-MS-Exchange-AntiSpam-MessageData: DWOlApBR7q4M5Ejl2po1W3gE3iu64rgEMXz2iKiZS0O2dA/i8beq7OV76nl3znh86UOfVCASMEKnmm2x13qv6BqoYfhpN16x1+mIIe3hFfWOPguBE7gJwpqQwGPYT8G06RekRPEsxdG9ZNPaj5Pjwmg/JiYxRYV6/YOidjn8aASXoStMWUhrJy3KYdNEPaLk
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a2905c4-6400-47ce-10b4-08d7e7167e2e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 23:40:08.9468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jW6Oj33P4FRKJsXyqeNpeXmdl+r1u9LltWiVdj9vjLxJnTPhflK6JdD1zciKsw5B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3301
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_08:2020-04-22,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=885 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 suspectscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220181
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> [Wed, 2020-04-22 10:23 -0700]:
> On Tue, Apr 21, 2020 at 12:23:30PM -0700, Andrey Ignatov wrote:
> > >  	if (ret == 1 && ctx.new_updated) {
> > > -		*new_buf = ctx.new_val;
> > > +		*buf = ctx.new_val;
> > 
> > Original value of *buf should be freed before overriding it here
> > otherwise it's lost/leaked unless I missed something.
> > 
> > Other than this BPF part of this patch looks good to me. Feel free to
> > add my Ack on the next iteration with this fix.
> 
> Thanks, fixed.
> 
> Can you also comment on "bpf-cgroup: remove unused exports" ?

Sure, reviewed.

-- 
Andrey Ignatov
