Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30F02AA21A
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 02:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgKGBxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 20:53:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1420 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727129AbgKGBxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 20:53:03 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0A71qnns021486;
        Fri, 6 Nov 2020 17:52:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rFaeVhOEDp/3+krIWIZerqycqip1vUFT9uVVAuk+LtY=;
 b=OmDDtni9JYcrZ50XMYda526v8wvmpaETDA4EkayXJGHulrc6jif4UbgSLQysdzHS0IME
 4Di+63TDI2YhkrgaIsVWdE5XwTa2xy2PW7D3KvroYsflsYDycRjhz+xNCt/0A9KiUhw7
 dIOCPzEoUg1tLsac+Yh84f1NgEkNbQjtlTE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 34mek3ay32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Nov 2020 17:52:48 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 17:52:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iS9ief7ro4VlsgSooEwzRwk+2OIeZNZEPxu3h9sNVMrin1hdln2SMclVJ/TP8y9xwRBkEwcEJ6H2CrcvN97G2TXSQgKD1xQ9cqoAjOslEB30IX9Jpc0t41Gm8b1LAvv/4CYSSGXMyNxovci00PbC6xKaCGxFmYnPcVuiWd5iwp438YV17B5gNGsGUcX9O+U8Mjkcf3xIesJ9C/OPfPFHx4AYXvaWZsBrnJA4K7vymLbKnO+e7pLZITxG6tU/JjG74T5/2EuX0uaIHQUe75340EXcqIjHUlcR/Zh9YiHxHVvmy2NGc44pCjnm0P3KMNjAsAw5rlMDImlzdEPrqc+A7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFaeVhOEDp/3+krIWIZerqycqip1vUFT9uVVAuk+LtY=;
 b=B1nxqW/6ntd5PUIgoumjBI6I6eVp+kY7hPrcPeLo0wrtwcTPFqkZkOoehp0nKj7B05dupG83EIe7HDzUgZTlegwtvwRyBmzhEZ0RAmiA0dxvPXTwSNkQtjuzs37rjeXgKZmaYJfUejIwb+0akevKUF9mNIwudhNfYJFhLWve7YxUVpU8vUlREBSihek88GtPM/87ubZ7gGIBtIzP/FOI3XgtIFA9xMIXLpq2O7UPtfcoOmlHIW3r5rrLdbG5N6Yy5WPXia6fN49yRf8YnLaU3vgQyu/X0qMPaBk/XFVIf6w7KWhQpPF1xEf1WWh+ZDMvE3Or2SSp5tegDkSHb+eISQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFaeVhOEDp/3+krIWIZerqycqip1vUFT9uVVAuk+LtY=;
 b=Kr37IRFfIoTOpkqzVhA+nYcPopTCNZIkKpNeeVfb5n3aBru9jqkrPJKr4yxVG3wgaKmlsMAX6dkh6AwDmCreG7g78F/wCszZ9Bq+IMRJGUn1N9wM3ohkM3mm0tU7OjZmXlkOFeufo6dkTFOSeefYp9Cv5o5JLQfs2yhGhlJPwy4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2454.namprd15.prod.outlook.com (2603:10b6:a02:89::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Sat, 7 Nov
 2020 01:52:32 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.032; Sat, 7 Nov 2020
 01:52:32 +0000
Date:   Fri, 6 Nov 2020 17:52:25 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Message-ID: <20201107015225.o7hm7oxpndqueae4@kafai-mbp.dhcp.thefacebook.com>
References: <20201106220750.3949423-1-kafai@fb.com>
 <20201106220803.3950648-1-kafai@fb.com>
 <CAEf4BzaQMcnALQ3rPErQJxVjL-Mi8zB8aSBkL8bkR8mtivro+g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaQMcnALQ3rPErQJxVjL-Mi8zB8aSBkL8bkR8mtivro+g@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:3041]
X-ClientProxiedBy: CO2PR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:104:3::16) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:3041) by CO2PR06CA0058.namprd06.prod.outlook.com (2603:10b6:104:3::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Sat, 7 Nov 2020 01:52:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40c2769a-6345-4c36-2eab-08d882bfca66
X-MS-TrafficTypeDiagnostic: BYAPR15MB2454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2454580FD21B582CA63B824FD5EC0@BYAPR15MB2454.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O3xPi2Zox3h12S/m18UOT9pesu7JAaCpzHGHas/HM6JMJEfIvMNID+UfRYfqwr+aBoI5mTJBoVxOYwvlMt6xrxPH7zTNqoFn0wck9Hy3TblL0skDYC9dcupZX9VXSR7y++ckPZXauyWC2/66nGzhXZyRM8AKwm2X9XD7ytuZtA7sDqBo6jk2VvuVI6LofFcIijmcFbaM5XYVdpOAZVfTwHxeBMezUQVOR9WSzG21u5Im9jVXYL26eLovMDfFz2aghiGQvjXApS6n/AKFQetiPQFDrURvkjIvO/Lhkitvy1/MhUnHKjGKjrrHBN+xKZOpP2aLF6ak1ayfjC1+liCk9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(66946007)(4326008)(7696005)(55016002)(5660300002)(66476007)(52116002)(2906002)(66556008)(16526019)(86362001)(186003)(9686003)(8676002)(478600001)(6916009)(54906003)(316002)(1076003)(6506007)(53546011)(6666004)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: JM13NiU0PhuNDDE4GBSv2F6KdK1wg8AH++zXBio6MyjFYLSFi6vH+CZhc1ZQMvq64Ucf57pMbsh0EYIiFv7nUBdFWOTbLIFIKBcNQxSjA412Pvoy8sNl0HLeI5vlV6lJO6+IXESEQkVb85ZfZ9ZCBtZlUR0PufBT9lD5bCxj1CyHiNI9TBCXt8qIvEp4Qv0LLYwXzK1WtVOrQgPUtGQMEzLeCw/jvoN15R8H2jLEAvxt+k+b8PEOA5hluKtbleBx/rLkt9q4TU+uPvwjlkDgMG/uumDGchJG4la75prWFA0EXz44PjtL1pYgTi4UHrxW4uwKMMCWkPItmIcw8+LpuvAplYISr0wdQZ9UnssZi7qsIt1vsFhVeeIawp7RNXheLZoqPJf8WsMBNQup9YX+ge6QRMA8ZnjvNN0sFg+T8dD6EVKtEgvgHY5AipSgzkndmcwepPpUUiEN3napQiW9Ja4rHAYrhJCSfYImtYqkBzvvuEfnNgXhOQjzol3LbWaG6DTFIv5RcnODZ+VLz/cvecjdiPACTXy7SrO/TYmNZpvEEDvbBANLzrA6n30chktdUaNDlzksUFzPwQDflqX5gN+NLIQnjZxnmUTzLX6gliY2L4i2MwLUOMaWXJbazYF6LOjDNNKheXH21ihPS8wOwpzJxlcmQVXoslWEtOwGCwL8HrI89s7ZVWnUR11GoOyM
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c2769a-6345-4c36-2eab-08d882bfca66
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2020 01:52:32.0982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QF5/FF5WEuNAd9FFBSeE4nVyNvAeXm/PnB4yezyYcQRyX+MTxWTI1cNO0vtxovT/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2454
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 mlxscore=0 adultscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 suspectscore=1 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011070011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 05:14:14PM -0800, Andrii Nakryiko wrote:
> On Fri, Nov 6, 2020 at 2:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> > the bpf_sk_storage_(get|delete) helper, so those tracing programs
> > can access the sk's bpf_local_storage and the later selftest
> > will show some examples.
> >
> > The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> > cg sockops...etc which is running either in softirq or
> > task context.
> >
> > This patch adds bpf_sk_storage_get_tracing_proto and
> > bpf_sk_storage_delete_tracing_proto.  They will check
> > in runtime that the helpers can only be called when serving
> > softirq or running in a task context.  That should enable
> > most common tracing use cases on sk.
> >
> > During the load time, the new tracing_allowed() function
> > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > helper is not tracing any *sk_storage*() function itself.
> > The sk is passed as "void *" when calling into bpf_local_storage.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/net/bpf_sk_storage.h |  2 +
> >  kernel/trace/bpf_trace.c     |  5 +++
> >  net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
> >  3 files changed, 80 insertions(+)
> >
> 
> [...]
> 
> > +       switch (prog->expected_attach_type) {
> > +       case BPF_TRACE_RAW_TP:
> > +               /* bpf_sk_storage has no trace point */
> > +               return true;
> > +       case BPF_TRACE_FENTRY:
> > +       case BPF_TRACE_FEXIT:
> > +               btf_vmlinux = bpf_get_btf_vmlinux();
> > +               btf_id = prog->aux->attach_btf_id;
> > +               t = btf_type_by_id(btf_vmlinux, btf_id);
> > +               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> > +               return !strstr(tname, "sk_storage");
> 
> I'm always feeling uneasy about substring checks... Also, KP just
> fixed the issue with string-based checks for LSM. Can we use a
> BTF_ID_SET of blacklisted functions instead?
KP one is different.  It accidentally whitelist-ed more than it should.

It is a blacklist here.  It is actually cleaner and safer to blacklist
all functions with "sk_storage" and too pessimistic is fine here.

> 
> > +       default:
> > +               return false;
> > +       }
> > +
> > +       return false;
> > +}
> > +
> 
> [...]
