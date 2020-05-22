Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879A81DDB9F
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730287AbgEVAHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:07:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26536 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729771AbgEVAHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:07:07 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04M052TR005975;
        Thu, 21 May 2020 17:06:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=XO6kG0iM+/M6W46pJHF2j+YPzfcLgC/9YvYiexjiKBQ=;
 b=GNUzroXjQHuy7U1pZx+E4IHERROVZuMaQ5lQkSe4KAZ2V99D9HHdKVxtzrrLDFlMKwJj
 knuNrp0FZHLpuXcWdsz4OjAq/EkFXJ+CaZXMQN1LD4eUNCjv4Ojrr/0nJ+DQNISnTcWX
 hPwRerSnJKquJXWI9RvfqYNLZpeDe4kfJ5Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 314jubm2m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 May 2020 17:06:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 May 2020 17:06:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAYudmxSJJOVHlj5bAeohiOgulWOhTc7dUQEhrAzyOZK1Nbyfogt8EiNx0En5UMO/Qs4no29nfkkcYX1Fag4Ri8mQt/oLGgQv/nRVibneO777vUbSGVhi1Ta3hjpI+1ABKuia/udSkXs7YVm0Xf7KbOzsrbotxpgbXi7QH0kUtQSld/h/fRyOpt/LF+PMHbW9mQHGHHv1HV7sPpv6HstD/IXooushb71CdanIFL5wwKzNuSVb1aVe9W4Hm6g5fQED3nTXmmZ533eObIfq/BMEEYpGpg+4ncYJgIxl0glqUs2sqVYXr1K3AkA3JpOM+e5ozsZKQqYdmlqXbun7r4NoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XO6kG0iM+/M6W46pJHF2j+YPzfcLgC/9YvYiexjiKBQ=;
 b=OkCs6rawIZCkq9OCAaR28FPUEHSHI9ZihZEwvrNNVQYi+5GuSf4UOYlJtnD0U3+qf+QtS68WQLzzSUeiHBugI39dKNxhv++zETW1xFgPCKVApqsRatT90XmskeathZrkCQSQTrNsT8Sc42jRluGNxnN3JeowNiq+i5bc8pac74fVeZxo9nxkD8iyF1WXX0u5avCyAVgAQ8oxpNhlur/pweuNSAQI0DyiBJjjvNnQ/FGbxxUBEhD9WKlgUY4boOmLR8vIN6lUnL+cn55B/qvHav3xFzxdY3xzoJRUQAt5UFZrXdJc6I4OATnrQXwwYAWqvh/gJvmlHNRPMqJww78yZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XO6kG0iM+/M6W46pJHF2j+YPzfcLgC/9YvYiexjiKBQ=;
 b=bvhRqFDt1+cEjSv9Qho2P1ZyLpP/cH0uL0tIKAhn1WWEtS8ybc0QyOZkQe/NU8O1aEC5GetPfiB9xTW2CaZ2r6FhUkRJWPjKZnViRy939rDORv+Yyb4vR4XM11DLH+wZWOxbih7gMspCGJb9t0EtyDiOXE4nndc0e2KrMshPhNE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3716.namprd15.prod.outlook.com (2603:10b6:a03:1b4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Fri, 22 May
 2020 00:06:50 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::71cb:7c2e:b016:77b6%7]) with mapi id 15.20.3000.034; Fri, 22 May 2020
 00:06:50 +0000
Date:   Thu, 21 May 2020 17:06:49 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 0/3] bpf: Allow inner map with different
 max_entries
Message-ID: <20200522000649.ggnjkrtawbmvxibb@kafai-mbp.dhcp.thefacebook.com>
References: <20200521191752.3448223-1-kafai@fb.com>
 <CAEf4BzYQmUCbQ-PB2UR5n=WEiCHU3T3zQcQCnjvqCew6rmjGLg@mail.gmail.com>
 <20200521225939.7nmw7l5dk3wf557r@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZyhT6D6F2A+cN6TKvLFoH5GU5QVEVW7ZkG+KQRgJC-1w@mail.gmail.com>
 <20200521231618.x3s45pttduqijbjv@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521231618.x3s45pttduqijbjv@ast-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR11CA0042.namprd11.prod.outlook.com
 (2603:10b6:a03:80::19) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:510e) by BYAPR11CA0042.namprd11.prod.outlook.com (2603:10b6:a03:80::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Fri, 22 May 2020 00:06:50 +0000
X-Originating-IP: [2620:10d:c090:400::5:510e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd524128-bc4f-4c20-609c-08d7fde406ca
X-MS-TrafficTypeDiagnostic: BY5PR15MB3716:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB37162A1A28F3448C2087D60CD5B40@BY5PR15MB3716.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: glstEkKkFSZE6PCkTZOi9z1I0KkR41qyEu0WuCRUI2lhnklKRIdVdx90bIamYYYzajsPDVsO62d3ZooB4E/GwRBLzqtGeGl0RtMhGDlxlUIkD1zvPxFiIoUEXeeTCWv7QKrl58+t3phcWw0px6A2hwm/fVuFym6Pjk8m0zZEkN1P+RV0322+K+vdaoNK9zuiOHMC8e0td9i06YrvJYySVnv6HIcjNYl2QJlGybsdBjdFz3l6d1T4CM1d59u5asX5FuIOTNdcudDENKeoQDpbCxyElwJf502ro88y+4Qu/qyDy9+TKZkGJ7Xx+tasxNz4qPExGINkegbqQlLmb4FL9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(396003)(39860400002)(136003)(376002)(6916009)(66476007)(55016002)(52116002)(66556008)(7696005)(4326008)(9686003)(1076003)(316002)(54906003)(2906002)(478600001)(3716004)(5660300002)(86362001)(8936002)(8676002)(66946007)(6506007)(186003)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: XG1EZD4IY2IDy6HSDQmUJOC7ZtH8dY9r/T+NYE5hdJvNF35wq06U0Nc6gKPDyfTV6jv+mMXLS2fWakdza9c0a4POWDL9+4yrOuAgnMWW29KeUrjSX94l/787unwfh+dje1XwlhzCzB5Xg5XgFNYGc/WJZ/QEXsMu/0/yUgw6izI8RcSfiGL90fIA6Gj4bLep/GdR9NVryYG29CRx8FXD3ok+RvRCgI4F1h5lGZDJh2jEk5X80adM/uxyDiElFeiqK7OEKgZtxPy0rZkBX6D4C+qBcIpj5rTtrmEFfSNXXQBLqZE0dAA7bkxDZfOJWxySQiBhgVbzb4wQWcqnKiJc8GOqEbneVR1RNee/1E3MWmsB5uBmDi/7WUPBp9vQKlVqPu1JttSuNYKEI/Q+XXu5yURnB8VUKE+TUnwYy/YM5bK4GbFvmI7CUhVIyuzN4AlmQrj9wsq5dQ+kL9i0CkRZyCWskAYVzbBCQ/wnH1gjckQHQQ27dPUXJgVvn3bqRE3Eo4FX53aL1jLZNnZvhjm7/Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: dd524128-bc4f-4c20-609c-08d7fde406ca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 00:06:50.6650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQTSWGOz384KxGwxpa7W6mTxVzUPQvlisadQC7euxDEFhk0Fztc3kRzxcaU8CodZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3716
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_16:2020-05-21,2020-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0
 cotscore=-2147483648 mlxlogscore=662 clxscore=1015 bulkscore=0
 adultscore=0 impostorscore=0 suspectscore=0 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 04:16:18PM -0700, Alexei Starovoitov wrote:
> On Thu, May 21, 2020 at 04:10:36PM -0700, Andrii Nakryiko wrote:
> > > > 4. Then for size check change, again, it's really much simpler and
> > > > cleaner just to have a special case in check in bpf_map_meta_equal for
> > > > cases where map size matters.
> > > It may be simpler but not necessary less fragile for future map type.
> > >
> > > I am OK for removing patch 1 and just check for a specific
> > > type in patch 2 but I think it is fragile for future map
> > > type IMO.
> > 
> > Well, if we think that the good default needs to be to check size,
> > then similar to above, explicitly list stuff that *does not* follow
> > the default, i.e., maps that don't want max_elements verification. My
> > point still stands.
> 
> I think consoldating map properties in bpf_types.h is much cleaner
> and less error prone.
> I'd only like to tweak the macro in patch 1 to avoid explicit ", 0)".
> Can BPF_MAP_TYPE() macro stay as-is and additional macro introduced
> for maps with properties ? BPF_MAP_TYPE_FL() ?
> Or do some macro magic that the same macro can be used with 2 and 3 args?
I will give it a try to minimize the code churn.
