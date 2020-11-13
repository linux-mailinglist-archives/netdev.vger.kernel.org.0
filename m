Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F352B1339
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgKMA0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:26:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40032 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbgKMA0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 19:26:51 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AD0Gg29009431;
        Thu, 12 Nov 2020 16:26:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=GhYviT4Uc9n5qdJXBSSlj8jsWO6PHVpOyh69N9gNgtk=;
 b=I1tuErGbId7wOMuRgDKdQtGSwnJeTR3WfYBdbwanleagzWL0NJCEeLscpnxqQ21Tbjcu
 snmRIjhc8McE0UQC9y1f2kk7CYDGDJYo2gPvr8pQbDwvbVklxkH7jS8mCDX14asFSyI9
 SFsJXogzJAq9PQCSEmmhXavQSC9jNVCVoCo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34rf8stppt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 12 Nov 2020 16:26:21 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 16:26:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfooogUOSl3yII6QZSPaYcBW0Cm2eVX5wNIZ94UWBbkuHVx14/FSla0apxCg4euoZhZfcZI3A+Qq5Ej98BLQsG7Od3/Ac1if7EXzImE+Gd3Itf26tqlghX1arPNQ++4iGe9+1k+KWNR1CX0WtpuGPERsKA7guY0YMgWg5mV2dGCBxpEy8Xy9ozPPsak3wnk8isB/sZ6jJ1U1kmI7XMIasak4fdN2DDWX3CuF2RSkAdlNUenQDsnWTOHse2p7Zs/zYa1tKweOhNn/XUJeKu55HL6phUreOnZMKd5fMM2/5dzLQbCFMte9UFJSHFbejkmQtIrzOCrtdyAv/x5yp2i8Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhYviT4Uc9n5qdJXBSSlj8jsWO6PHVpOyh69N9gNgtk=;
 b=YPaJp6QoLJ34c9zguyR3puBaheOcI42ftSbMREn4Vld8Q0A8vblrEIEhOpIE671D0ZAWTTojpU2FHLcOZey6CnjVTU3NPQr4kF1tAhhZ0G66jGEJ9fNYL+Ls2L7gJ0dOlmKIoyEwXsJGencx7VT+Fus2lGu7TDHJrGCBQsdpVZE3lt9AErjCLXzJzoVm1zgtkJItXrRu7Xq0M1sLRcFjH1RwdL9IgBSvWwGm+RPjjAwK74c2NJDuMJpzcwJS4lrfZ5K2duDT5qCl9U3GWMODXJQv2P/7ltvLZYFBNGGJ6994bXydXYEZaMUpjapEMmKogZ7j/bU8ERMJa/7Fqu3eLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GhYviT4Uc9n5qdJXBSSlj8jsWO6PHVpOyh69N9gNgtk=;
 b=SZPZmf0jASCoY00yze5nFT5pzG9G1XwvoDOfIa9SRBWdgwkVPBeth154GmHy68GCmun1080BtWNCmdSrSrlau/5yAu+PQizuNjBSHYC1uooNlq+VSeWRb0D8b5AEDaB9tQzu7tk8legnTHdi0aLo1VIsRW6a7njUF9eajHjQciU=
Authentication-Results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2343.namprd15.prod.outlook.com (2603:10b6:a02:8b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Fri, 13 Nov
 2020 00:26:15 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::d834:4987:4916:70f2]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::d834:4987:4916:70f2%5]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 00:26:15 +0000
Date:   Thu, 12 Nov 2020 16:26:10 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v5 01/34] mm: memcontrol: use helpers to read
 page's memcg data
Message-ID: <20201113002610.GB2934489@carbon.dhcp.thefacebook.com>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-2-guro@fb.com>
 <20201113095632.489e66e2@canb.auug.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113095632.489e66e2@canb.auug.org.au>
X-Originating-IP: [2620:10d:c090:400::5:6516]
X-ClientProxiedBy: MWHPR18CA0059.namprd18.prod.outlook.com
 (2603:10b6:300:39::21) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:6516) by MWHPR18CA0059.namprd18.prod.outlook.com (2603:10b6:300:39::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 13 Nov 2020 00:26:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5be0190a-5d96-44eb-6075-08d8876abb8a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2343:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2343A558E5DC223F3487855CBEE60@BYAPR15MB2343.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iQOF24VYkjB59rTcNQBmfzETBabZWH+215kFhIR3JxcrKq+I79rxb81ogIC8Eh5YENJ+Gtn7mzalKeDDR1yw7hZ5uflT/beOPVlqHIfy0SaZJ9wwDwAwlPy/7NKQH7FSyDD1fFLLkVVJWGs9yahHAiOBUpr4OH1euGGCi6+7WpSb/95oppuMpx2Lt7ErB1ZYiAAZXUFyUCZmUMI8lH66rpdlbgB+8us/T2ZlvOM9EGlddPgGql/8LRpDRXVzwwnNl0RGf9UA4cBR0wUxBds3DJQ2apnkwM7PsvuYowluRGx6m6neaxLOEcrq/Tr+NJAPoZboNzacC4oJyO2uanxwxh159hP8t1LfSkqrfzOVLNcdD0akF5etJ3d0ABEF6Z1fEWjMzKXsaN11vY2uBe3vUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(136003)(366004)(396003)(83380400001)(186003)(2906002)(6916009)(8676002)(55016002)(966005)(8936002)(52116002)(66556008)(6666004)(1076003)(7696005)(7416002)(33656002)(4326008)(16526019)(54906003)(478600001)(6506007)(66946007)(5660300002)(9686003)(86362001)(66476007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: N/JidN7+MtCebFcyi01ou7lawwNJajITr5IcooY8m8FoeFMYt+72Ro0ujd7W8MVDiizySUVENo4HEpKiVgI3TpXvRYobYDsh4hXQDl24BsvHv0whhusz2yz7+nAwEEl2ekOP5Ylvaqa+iAEQBZJna70gCFWcF2d0NTgITzPzd/NEaFQJ1svc27C9MTBuPjw3VgaKshPZOGJoFKbZvcl4wDWvIkufAOCn9SpjcA7nuZXR48li+dhxVFzcCyK/uV1jJnBQsL4Wyg7VV2oqHv6i0ITP/JHLgf8WcIjOM9DuSffGBwcJe7G9gYrKECOxBb3uUMhKQRPDUadSY0et4Ef8ajjY1kim8jE5W+rxY+XnsXDAUR8z2D3TybUPX1gTXd4usTlyOALsjnBkH+P63LtHsIM/q4g0nY73QL+g/aRJTif15xuK7wNPXUTHclzzJPNhFN9EB/73/0b617L9WgKGiV38WaEUd3OdrjYoz8Er6r7Anv1qQfSwGm4QWfm1pS1rg+1keefNElKvt3HDFYzNVS/VZQm2dvCxuwyxSlL+RrjURieNFqCIZp7AU+mwMI8iVjOt6rbbqyrMpxi1fOMTEyBykM8Z9N+t/iJTuINvcNBteKNXPwcir3BQnlIycLL93ipXTewGCaV/VNKOVez+baanWKmMaQNPxHihzNAAixs=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be0190a-5d96-44eb-6075-08d8876abb8a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 00:26:15.6915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XuyRvqqoGN885xGoGLEIng2jjX5ED0g7C/CRRk02TIUj+O4yvw/zDyoJBQR8qXPZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2343
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_16:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 adultscore=0
 impostorscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 09:56:32AM +1100, Stephen Rothwell wrote:
> Hi Roman,
> 
> On Thu, 12 Nov 2020 14:15:10 -0800 Roman Gushchin <guro@fb.com> wrote:
> >
> > Patch series "mm: allow mapping accounted kernel pages to userspace", v6.
> > 
> > Currently a non-slab kernel page which has been charged to a memory cgroup
> > can't be mapped to userspace.  The underlying reason is simple: PageKmemcg
> > flag is defined as a page type (like buddy, offline, etc), so it takes a
> > bit from a page->mapped counter.  Pages with a type set can't be mapped to
> > userspace.
> >
> .....
> > 
> > To make sure nobody uses a direct access, struct page's
> > mem_cgroup/obj_cgroups is converted to unsigned long memcg_data.
> > 
> > Link: https://lkml.kernel.org/r/20201027001657.3398190-1-guro@fb.com
> > Link: https://lkml.kernel.org/r/20201027001657.3398190-2-guro@fb.com
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > Reviewed-by: Shakeel Butt <shakeelb@google.com>
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> What is going on here?  You are taking patches from linux-next and
> submitting them to another maintainer?  Why?

Hi Stephen!

These patches are not intended to be merged through the bpf tree.
They are included into the patchset to make bpf selftests pass and for
informational purposes.
It's written in the cover letter.

> 
> You should not do that from Andrew's tree as it changes/rebases every
> so often ... and you should not have my SOB on there as it is only
> there because that patch is in linux-next i.e. I in the submission
> chain to linux-next - if the patch is to go via some other tree, then
> my SOB should not be there.  (The same may be true for Andrew's SOB.)
> In general you cannot add someone else's SOB to one of your patch
> submissions.

I'm sorry for the confusion.

Maybe I had to just list their titles in the cover letter. Idk what's
the best option for such cross-subsystem dependencies.

Thanks!
