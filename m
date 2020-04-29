Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0D51BD448
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 07:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgD2F6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 01:58:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39422 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725798AbgD2F6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 01:58:54 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T5uw1M004440;
        Tue, 28 Apr 2020 22:58:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=wQx2YGibBA3YyHPFNBldeef1cSSNRREFKng+9FwQ6ds=;
 b=JhvbFg53+g9EA9KjIRoIohGgD/QkTZIjc7w6l9yRy14urxgybk47zj6XRTIGKwfJl6on
 xdok4VNfE1DNTBTaOrk3nfyzNr5+KCVdziCrdHy30s/0kj8+DzV+7Byp68OAF772UAGO
 GKHuv9+qwYjw5JTc2cZ1UTopyyvOqaiArTQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30pq0ddgtj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 22:58:42 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 22:58:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fo6yyM9Jtch1/xZWIryvpNwlDv1RHe8q/o3hlPUNmJv+uagxttuY87thGJJfjV7gOFDnigypJETFdEcpszb3KUwwyC7q8kKAcBquzKULgohMH0oYg49jHsPl4XVPXflckNforrWK/8Qcl60h+qkH2luY+xDuNC/bBE4U2ExS3mxOLct5Ij3IURKgk7BPE0aCyv7qWPPHP9l1Z7R49QQtv76KJa5Gzf29WMYNkpFE0HFqFNP9iutq2DmR3/9mVcl+CZrt5uCo+sU8Sx7SM6/3OuPgFFKV/xiizxZogRGJ44p1VYwjON1fjWfxpd4dTawU33tKDmRftLLdjms8VnAzuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQx2YGibBA3YyHPFNBldeef1cSSNRREFKng+9FwQ6ds=;
 b=mbShsh0UInrKBOjB81hwccMcgzVg6URk9g9w++1F95Xo9o3awTWCWaz/unxOQ5C2+n86ZNrmoCTtBrrWgc/4CrC2POEuoh2axMOQT93nGs5DoPJh/LseqHeIyAWk8P67wkMCYytGsJrifWdEmoMnF+mbxHtBJfXCBnkXoXcvh6A3KNCCkdMZGy8EXLQETjtBStTFkqUWjYy4OG8iyIQTfsfXHtY3F9Hqqjsgo3ysz1cOtAT93XXECQ+hijMa27wkYtfWL9DRziuYB8a7vxrcrpX1W2bxmNb49c2nL6Rru/6NcTDt8OSbHxIuC0ITbXAZ6/EHtmvBUfmQB1Zb+POeHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQx2YGibBA3YyHPFNBldeef1cSSNRREFKng+9FwQ6ds=;
 b=CioTs3mXuU+qFT3Cn5E9CZPzv0JPjqktApplMBgeVZAHVTlc1oV89FbDv/m280J6I+3rMcu0ZzTphOIngB3Qwb4yRxp4o3QntRNZpW2zBSRdxVKN3fxyua9gVedUOOHGEtsWfYVrHxzZXO/PLBfIsiVv1YiOpquLP3hl30x1Y+U=
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB4009.namprd15.prod.outlook.com (2603:10b6:303:51::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 05:58:40 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 05:58:40 +0000
Date:   Tue, 28 Apr 2020 22:58:38 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v1 06/19] bpf: support bpf tracing/iter programs
 for BPF_LINK_UPDATE
Message-ID: <20200429055838.feupa5leawbduciy@kafai-mbp>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201241.2995075-1-yhs@fb.com>
 <20200429013239.apxevcpdc3kpqlrq@kafai-mbp>
 <f63cd9f5-a39e-1fc8-bba3-53ebffef9cc5@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f63cd9f5-a39e-1fc8-bba3-53ebffef9cc5@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR08CA0056.namprd08.prod.outlook.com
 (2603:10b6:300:c0::30) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:1f77) by MWHPR08CA0056.namprd08.prod.outlook.com (2603:10b6:300:c0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 29 Apr 2020 05:58:39 +0000
X-Originating-IP: [2620:10d:c090:400::5:1f77]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c825aa5-4280-4d91-9a42-08d7ec025dbe
X-MS-TrafficTypeDiagnostic: MW3PR15MB4009:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB40098D57FB95ABEBE439E823D5AD0@MW3PR15MB4009.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(136003)(346002)(376002)(39860400002)(66556008)(66476007)(66946007)(55016002)(4326008)(1076003)(5660300002)(9686003)(6862004)(6636002)(33716001)(8676002)(52116002)(86362001)(16526019)(8936002)(186003)(478600001)(54906003)(2906002)(316002)(53546011)(6496006);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qxmEAKy7uRJb2tJEQP8dBPbebmLQXycl7qjE34rWCvC1djiOHOo+cJpGyDJG0HIdUmo2p/Qq4aJV4jLE7CwZDDlO8CoyR+GMzIo5dc18r94DpG9z8R5n+5nGsh9WNup40aZ1vTZPwIwY2ONX7cB9HfwJDRfX8PGFEHVGs8d8pu20pxkNYsMFiXf8bsWP/UYmJTRbSlS0bAoYAAOZAbhFBudLrDshzO+nWbMCWuqKlwkpG3+//VmBBCGGbQCBYXLkJcB+xMXdws5FO3UVuOy+31ebW8n3RNrt87dHxvVxeEDF/kdIeKPwxDSahEHD2TW7WFvLxowXfXfzBlWgH5RLX/nhnzZJSUusTAllLBmTULQj30MPbGuhGYos6QudjGcT65T7DLZ/zx/MBl9fzZFjKpbEJKklY/MqtbiU+CZ0FF4oDI8Iv0bmDqAQczNlMBse
X-MS-Exchange-AntiSpam-MessageData: MN3sMmBko/vuSevdwghViMvXxRHxukQZ9ES0wQfqrhTGzOkvSQExnjgEFzbh8A6RuXv20dd1rAVygiXG4DzcyXI2gH+43rq6xoJGeGkqnDOgzGijlf9BW06KMb5bGTjNu+zEOyY6vFiNUAC7N4/0DRL+7W3RfgUG8MGtRV7LIGu6m22KHZv7SdY0zvtuP1VXA7AmDKKePTCp0tH9IysVAu/n3LuZn5t9I2jBGO4njRpq3asJTGNhbesdGmZrVwekkWzqwOhhXEliWKCiVqz9C7gOzZjTsBOmxhbVGr5mYelu2bU/B8VULsm8GiyYea1GG+CSvv60hJn/2Wxv1M5oDu1jUAPXtea1Kj66vmsvJDqHX7Ferrp+3R9dxO8hkEbjCX4q6Zc+VHMlsfHaqKXVXEYNrEzHDrH43E7bdStlOrCkRuoYwNqj26BPnUbFiWqqO6aUH08b9LCZzzkRBIMk2WwXeW0QuxewKmrEvAFg/XQj8ylj3owwmlOb+ZXPlNXWM62Rwlztreo0q2Bi9NSsDeglhqnhrXAmz9mCH5YtxJZBkXwssxZTr5E3GNZfsivSUj8YB6ELj1ZHhmlBaWdxrMH1yA+pVzRoVG8Ool8VSmDxf2Xas7y+cQLZpWXnvX+6NlVzE/6xAzXCiADX3mOm36EIhkXOkP7RsNtBx0EmKw8fL3cRmpc9cyYSrY1ADdkCoWkAa40tyQqsm6zUSG8g8Pc7UT1CTYmPljH3AH2KrosCko1a0lapXwtSrGdQZvSsTKd77jmUcYYs2Q5N9KS8/PjBMy2tAGLmhGdkVZ47RoLoql05dc0kdCJVWs53fancNNUSi9nh8vYrKLwEzjdQTw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c825aa5-4280-4d91-9a42-08d7ec025dbe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 05:58:40.4848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jaJ+UNFp8P6t7JilcjZBAfbPCoXg0mTPodnAgHMhUSCXM66BS/5d0sXVMtPMehzU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4009
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_01:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 10:04:54PM -0700, Yonghong Song wrote:
> 
> 
> On 4/28/20 6:32 PM, Martin KaFai Lau wrote:
> > On Mon, Apr 27, 2020 at 01:12:41PM -0700, Yonghong Song wrote:
> > > Added BPF_LINK_UPDATE support for tracing/iter programs.
> > > This way, a file based bpf iterator, which holds a reference
> > > to the link, can have its bpf program updated without
> > > creating new files.
> > > 

[ ... ]

> > > --- a/kernel/bpf/bpf_iter.c
> > > +++ b/kernel/bpf/bpf_iter.c

[ ... ]

> > > @@ -121,3 +125,28 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > >   		kfree(link);
> > >   	return err;
> > >   }
> > > +
> > > +int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
> > > +			  struct bpf_prog *new_prog)
> > > +{
> > > +	int ret = 0;
> > > +
> > > +	mutex_lock(&bpf_iter_mutex);
> > > +	if (old_prog && link->prog != old_prog) {
hmm....

If I read this function correctly,
old_prog could be NULL here and it is only needed during BPF_F_REPLACE
to ensure it is replacing a particular old_prog, no?


> > > +		ret = -EPERM;
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	if (link->prog->type != new_prog->type ||
> > > +	    link->prog->expected_attach_type != new_prog->expected_attach_type ||
> > > +	    strcmp(link->prog->aux->attach_func_name, new_prog->aux->attach_func_name)) {
> > Can attach_btf_id be compared instead of strcmp()?
> 
> Yes, we can do it.
> 
> > 
> > > +		ret = -EINVAL;
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	link->prog = new_prog;
> > Does the old link->prog need a bpf_prog_put()?
> 
> The old_prog is replaced in caller link_update (syscall.c):

> static int link_update(union bpf_attr *attr)
> {
>         struct bpf_prog *old_prog = NULL, *new_prog;
>         struct bpf_link *link;
>         u32 flags;
>         int ret;
> ...
>         if (link->ops == &bpf_iter_link_lops) {
>                 ret = bpf_iter_link_replace(link, old_prog, new_prog);
>                 goto out_put_progs;
>         }
>         ret = -EINVAL;
> 
> out_put_progs:
>         if (old_prog)
>                 bpf_prog_put(old_prog);
The old_prog in link_update() took a separate refcnt from bpf_prog_get().
I don't see how it is related to the existing refcnt held in the link->prog.

or I am missing something in BPF_F_REPLACE?  
