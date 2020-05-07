Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD03F1C9C53
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgEGU1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:27:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63824 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726320AbgEGU1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:27:11 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 047KPxUI023121;
        Thu, 7 May 2020 13:26:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/0do0h0tKjNjhxUbnmhw7rnLkh149AnpvIvxsL80nQM=;
 b=ij5jcFIM5XsWHVeLdY8j+sq6BbBBsnBNOCIMq4e9VNh2ph71vfm2q0Zvhb6x9nTwfvRy
 xI4fmLEvHx82C3Zr79TKhBqaqfQAbBmbcJCDUguOMZqw5FqxbeMS9zXs2TPTNVF1MoBV
 vk7DK7+jqhzpYXHRdn7hi8X+cTMese7ObyU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30up69je70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 May 2020 13:26:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 7 May 2020 13:26:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oKjp+gFyo2iGzUAxOeG4PR1yxY7y0jnloetyawcEYuQV8n0L5Q5bRDhNCMpOKojOy6a3nswHGDYz41Hz5iGVh4yNK8nat0Gxqfygx0Y0Pu5W/54dSYYRUkXOsbAuB0jngRTvoQ/KADrByagX8UjK9RgI9fBY+H4vhnIhWifokdhA5qi46XT+rx01p5UkAh7YswnB8PB5p1tUqMV372PFIeY2Vha+DVA00QWcyGuQzC7ZuwpKKSo18HAm4vszqV6rOTQaYbWbrraoCn7/jItq4EJ9fskillAmm3FVrpQkfl2bjGa0zJRGvAnI5WQ1kbNn8PLR40s5on/hKwK0AmLkBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0do0h0tKjNjhxUbnmhw7rnLkh149AnpvIvxsL80nQM=;
 b=ZyhTns8ql73+PQ4hU5hMORl1eb5Hz3rdqAShZq3cIKgOz2fObpmW7GNPhfDp3Q23scRaxzJ1UC+EYra365faa4EhzXzWI1Ig1hodh7CJfKC7qE7DZ4Ag7uBvnwxzE2JQIDRp18VaPNRiv4sqS8Tkr+z1tCyeXMU+FLQ9NwXxOqAr0azuZsenthq3vNUiLgXuALnIkk19rqXxInNbCEZD0yKCiG5m7/PEFwnuAnSE3McI9ajNWfcxlLY1jCLUGwMuN+kZYQL1twRXP0EsKalpJcOoyaOACqSO7BBSzoU+5iBW+zbPbE2z12wbVG4wwV3jzLbNBw43B4bM9U+G0Xg2ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0do0h0tKjNjhxUbnmhw7rnLkh149AnpvIvxsL80nQM=;
 b=HO7/gX0zMomtXFq6TswTZ6z8XkiLZpgqx1T6PmfmB1EXhcLwwAF0mT+1ptqh5RJlsHQgobReIlKCCmBt7ecGWWwj+SUaMEbphXArvSn2qApLUQvKluZOe4FZthVjhh2bvQIYQhlJK0gRnW18tqkvqokz/5p93Rm/udWmZ1QQEMU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB4104.namprd15.prod.outlook.com (2603:10b6:a02:c8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27; Thu, 7 May
 2020 20:26:52 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2958.030; Thu, 7 May 2020
 20:26:51 +0000
Date:   Thu, 7 May 2020 13:26:50 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v4 4/4] bpf: allow any port in bpf_bind helper
Message-ID: <20200507202650.GA3757@rdna-mbp.dhcp.thefacebook.com>
References: <20200507191215.248860-1-sdf@google.com>
 <20200507191215.248860-5-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200507191215.248860-5-sdf@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: BYAPR11CA0090.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::31) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:504e) by BYAPR11CA0090.namprd11.prod.outlook.com (2603:10b6:a03:f4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Thu, 7 May 2020 20:26:51 +0000
X-Originating-IP: [2620:10d:c090:400::5:504e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee3e6450-3303-4944-1d6a-08d7f2c4f9d1
X-MS-TrafficTypeDiagnostic: BYAPR15MB4104:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4104D2123D8D6B3056F9D161A8A50@BYAPR15MB4104.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ldP2wx/moyz8r/+THiRZRDO+R5Cz/ZVTzduZT1dxFQR95xR+iJ1EH94AL1HrNVMyVkpfkhV4uWE9Ar4G/GpBeLoIDVmOzu/g9odg2njVeuLgAawV2HGxC76VNPVXZbDNC17hDVJo09teXDX2E7jgK/eaP80N8gk0F3OyvrgjldPVG+FOVVP1vMKfZBAjYpxZhXBPmmHpwTlMgdjBnjlCR8V62pFunUlot63pj54P5Dn9zxRD/V9ousTSX1RjiDtUpuFDZ7HVKi0favDuYPQCAzN0vHmi0K89ERCMLLwZPG+/SE6u0Yh3SJUxKxpa1RyO2hkdpmSfIFYn5hy02w3oJDynT2u4Wf6I57Pz+XBOMf0d5PnaBz5rFfZSpmVA+Hf/4pLXBT5ef+uImbpkzOjJYPBxKdlJWdS5p+n+4xfx6Zr5L0OwT3bU8ywimCUHuRwx+Y7ZLXfbuYMZgusk8LnexExQKVcpIJHNfUAPfbkpBYcv0ryYjzTxGIoZK/ZvNuJLL2t8wWY5iHzNUgn0pbotrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(376002)(396003)(366004)(136003)(33430700001)(9686003)(1076003)(6486002)(2906002)(8676002)(4326008)(6916009)(316002)(5660300002)(33656002)(66946007)(66556008)(33440700001)(16526019)(66476007)(86362001)(8936002)(186003)(6496006)(52116002)(83320400001)(83280400001)(83310400001)(83290400001)(478600001)(83300400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jVe+gh6+W3LbM2tE/29H+z0ST3fya5be7orNdlXAIbGxe2vC4J7HE9+UD4fyqhIZq86sw4ogyLD/z+/6IgGOhgzgtsQC7TN9e4CG42F6DkD9YxBIpSCavY6N4VT2Ul5nl+Nb9+5L9+aRM/UfSMzqhpDufLTKFWgdj+kueXMY38p/CyMZGQJNV5G8+FgA2dSvn+rNyZk5y+s7gYSeZL3uyN3hjJTJvKFg8YGMPwbQQRkGoKsuqJ4VUzsstMXgEjqpyxMPmh210CrUObN97U2kUCIpL6gWVrkXsQEQ4g5L+gH4Vol1jmYrbZzRpEN4gx1J2D2TbaYLOBjN8O/8u9zthg5xEIv7Tf76LXTvECYCRZV/NB79iyP0mPVa1fx4Atb4WQJI46ltg73ppnhYkVNTsZZrnJxY+bm4VCo5zgz/IW9x0Wv2n3v0pZ3PUDGVzN/Dt0uarBA0jzaCtofHCNgP4s79kmUKfCp47di37i5uOa7N/t4FWcNM024jKCSPv5McmmKJoCEFE4vIudaJnKx8AGd1xBAC1WnNlQy27u3seBurb960FnHVomsDmAo2QO6TovcjeLFchrIH3x1XtxatgyQTVB2mPsWVz5YajXgp4/UVvGD0dKqDivhxQHPfJsaogOONCNg2MWuClaM3SroFiRsnNJGiwyAP0VYx55Wh28oWYaTSbPo1WJKCgV+4wF9uLjYpTZoEeQHqCq1ntfPbJ9dTvHfX7Rvispe6Crb+XUBZX9yJu+NJ2ZgAF3OdkLhdG7Y/GPAlO5HfFPsuY+B1vh6YrCbyz4wxMCQ8giBNwjT4ftyjBKkSzYN+zCGVJtHlUNLaI4XCOyQqVPnoC2bIyg==
X-MS-Exchange-CrossTenant-Network-Message-Id: ee3e6450-3303-4944-1d6a-08d7f2c4f9d1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 20:26:51.8415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vi2UvQh1ANKXvq7As1JgAHOz4qtTJYbl68OiqWi/LfF+p2+3EtZnfTR3fOZyj89J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4104
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_14:2020-05-07,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=935
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> [Thu, 2020-05-07 12:12 -0700]:
> We want to have a tighter control on what ports we bind to in
> the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
> connect() becomes slightly more expensive. The expensive part
> comes from the fact that we now need to call inet_csk_get_port()
> that verifies that the port is not used and allocates an entry
> in the hash table for it.
> 
> Since we can't rely on "snum || !bind_address_no_port" to prevent
> us from calling POST_BIND hook anymore, let's add another bind flag
> to indicate that the call site is BPF program.
> 
> v3:
> * More bpf_bind documentation refinements (Martin KaFai Lau)
> * Add UDP tests as well (Martin KaFai Lau)
> * Don't start the thread, just do socket+bind+listen (Martin KaFai Lau)
> 
> v2:
> * Update documentation (Andrey Ignatov)
> * Pass BIND_FORCE_ADDRESS_NO_PORT conditionally (Andrey Ignatov)
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

It seems my Ack from v2 got lost so just reposting it:

Acked-by: Andrey Ignatov <rdna@fb.com>

-- 
Andrey Ignatov
