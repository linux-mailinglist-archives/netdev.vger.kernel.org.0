Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA0124A492
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 19:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgHSRCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 13:02:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37204 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726703AbgHSRCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 13:02:45 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JGxhRT014140;
        Wed, 19 Aug 2020 10:02:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=ZcFOSzU6RUdfSJBC5hlVZ/GUeek/NMMrBPm1OAI6qso=;
 b=ZDJ0ZjKL74Iy+uQLPRC0iv16AjfqVSa4zvy3V1UJ2SM/DqINQXI0RpAuYTKEJdTPrRE2
 o4NfCnv9XKcC7G0PxVkJ4GA04pLFXINAP/A1CCn+L70IZBNuOFpbesQZQ+7s54h+eYPl
 T8UK79wttqUzVhWpr/53uwITAkXHYH7SsSA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p81reh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 10:02:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 10:02:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3OyvA2OgyAUvbo4os7uBU1fY/0UKyg/t1/22xWK66IlSJhsJpq4Ix4R98yohSoKAdaPz+ri86LvFJtKKF60Hjaa/vjDLW9l3XA5LN8MdXVE1CijqBMjxwjdK0TVZ/euThhsD0UH1eJJ3ffLAToILJHkA8WTnK3OdSboQvyfIB1GojRHW6mbag+1+IfirNudPjukr9q5kMPUnYoM1TmfF+kD3UhtTgRVGv8qa7Qc7HaHO3bCtBeBQDMpM7L5oNDYRiWIwIWT2scNe/3mlQPzkk4lI2ia7w1VhmNngTK8lgu84XHaGDKQoKtJc8pIQieuVxTpKlTyYK5zWIsMgFmu8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcFOSzU6RUdfSJBC5hlVZ/GUeek/NMMrBPm1OAI6qso=;
 b=mtoBA5h/eksNSKE+UlOUm6LkacuWTwCfQHSiHcQ3VT8bTjPXXSGHlnf/UEy8LMkpBd5xrWMtmhK2jN9QNmdOzx6vvqtLbcbqlt7yJyCT3G01GHikkxk+veritB7Y7Dkq1xByDnqQJWt3cVX8YoDy4ChQYuy/Z0dssM1vmy1Fs4bx81Bx+hCp1WpHDqVD4sj/1F96bzthV0TNqPDF66OX2Y7ab+dDBtgaGpK/T7NSkuaO8yAgv7nbu72DYltnvYpeWqX+8/JNvC9h4PipgS60VLoCm4oWy53AGwiCnFu0omR0VuDqPlAFwMP1hrgcLSr8STe7PB6ceM4pA+TmDsrpjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcFOSzU6RUdfSJBC5hlVZ/GUeek/NMMrBPm1OAI6qso=;
 b=iCCbBwu7q1fwb8yMChQsNNcqlidUidW34Go2/c67gevB14p+uyXtiUN+2bVvaEubXCutmhE9gCTasSDN94IMJUTJomXRGE91kjm3FaXtk6CXUsxHF3BZaNxOSmOnzQQmdjDmm5re4K7im4ME25lNYb/EUDj+X4iREyT6UlvpC9E=
Authentication-Results: vivo.com; dkim=none (message not signed)
 header.d=none;vivo.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3191.namprd15.prod.outlook.com (2603:10b6:a03:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Wed, 19 Aug
 2020 17:02:19 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3283.018; Wed, 19 Aug 2020
 17:02:19 +0000
Date:   Wed, 19 Aug 2020 10:02:13 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     =?utf-8?B?5rGf56a5?= <jyu.jiang@vivo.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        zhanglin <zhang.lin16@zte.com.cn>,
        Kees Cook <keescook@chromium.org>,
        Andrey Ignatov <rdna@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <opensource.kernel@vivo.com>
Subject: Re: [PATCH] bpf: Add bpf_skb_get_sock_comm() helper
Message-ID: <20200819170213.ji7a4bwpeiei24i6@kafai-mbp.dhcp.thefacebook.com>
References: <20200810175529.qdsbziyoo6myw2dr@kafai-mbp.dhcp.thefacebook.com>
 <AFoAPQBqDUaFCjrcrhfZkKrn.3.1597817456174.Hmail.jyu.jiang@vivo.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AFoAPQBqDUaFCjrcrhfZkKrn.3.1597817456174.Hmail.jyu.jiang@vivo.com>
X-ClientProxiedBy: BY5PR20CA0002.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::15) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:af4e) by BY5PR20CA0002.namprd20.prod.outlook.com (2603:10b6:a03:1f4::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 17:02:18 +0000
X-Originating-IP: [2620:10d:c090:400::5:af4e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88292ce6-0662-4e96-a863-08d84461a1ce
X-MS-TrafficTypeDiagnostic: BYAPR15MB3191:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB31912095D0C9C0B445F73692D55D0@BYAPR15MB3191.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8PYG0BtLBNSEtbGsojLMo+OsZlKMip16iumb8fYMQZcZS07Ekcs8KTJAyUz5Gsuvm27+NtMtiMwg2tJ62C/gx4RoclyxJuaRzC8cEBJkUxUH0h2RMeYt+syfJXxf33AsA11sR9T27SVN5Nj4iEcE9zYFUf9vnMoMKBAm2QGxNIUFix1G4HtHRQ2e6UraHFEsPNfuFUsb07bg/rF7wya1vwJMgczXidTRNjcMwKaQnm+PMAr2owBpVYyjvIgFy+Vv98Nu6o8OMpnJuTyc2bWUkUSA4z3db3UN9qcYurf2qPNG1qWYTojG3+RKLjsARMHS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(346002)(376002)(396003)(55016002)(52116002)(2906002)(4326008)(83380400001)(6666004)(478600001)(7696005)(9686003)(66476007)(1076003)(8936002)(8676002)(66946007)(5660300002)(316002)(186003)(66556008)(54906003)(6916009)(16526019)(7416002)(6506007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: NvH47Q97WK2s+BxE7eZd72bL/hcQ37BYzc2gLiIa2oefYVuYw+1hHLltaZkwUDygHZBrUplD9rt2y6wUF39NpWcvMgMssDnOusjNMgoB9epgr+04jZkRwqA0VBcCzPdC2aSUMsDMQreSfSRUr+1KGQHUYQoyyDnElZEcady+KgOVgB/BU9vBbOAuICNxorFLiVJjdW+Npaf07COw2GkenPuEDnjlbhvuYt2lnESmhTSPHuIkyiVlWEpfVt7olAw/gaW850QFkFHAso6MD6lzsAxK3sAD3goK/OSm3a297qnJMq+DxqVyBvFzh4pbKbad46ZKfW51zzArpqbvgUOVLufk4N6/aKZc/+SbQ0bWd8yexR6X/b6hLtsgOSi/BBfp1ge2jek8epZezYxAwat4fRa6KxggIKEzKVvRKW2F28bD+RpYpZAIMY9FwVjrcboaKLUv62EtIvdMc0Yro2sDUbjCKVJdLVTBOik+QBpMek+1w9haxBF0WFpEkqDUH0coJOkpYGoy0/YIg8ogJcFe5+uoGykUJr2/r/IDdnetOrYcBt621Ody1QVJ0bf+jJ5IQtWcK7rXkraKHjopH7R1Gn0IAJSll1Ijk6qnGDMtEW27dQFtxipdm6KW6sQovrlp7DeVx44JCUqRosxQJvs7/qAbM4csmxUO1LHBTEc9SaM=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88292ce6-0662-4e96-a863-08d84461a1ce
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 17:02:19.4484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9g/opFVvHgGhwXoxkFFvQyYDJn2pfWZ+8Yx2N+jVVqjY1nl7wBPhCO1QqGZrXQv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_10:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 adultscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008190142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 02:10:56PM +0800, 江禹 wrote:
> Dear Martin,
> 
> 
> > One possibility is to use the "sk_bpf_storage" member immediately above
> > instead of adding "sk_task_com[]".
> > 
> > It is an extensible sk storage for bpf.  There are examples in selftests,
> > e.g tools/testing/selftests/bpf/progs/udp_limits.c which creates sk storage
> > at socket creation time.  Another hook point option could be "connect()"
> > for tcp, i.e. "cgroup/connect[46]".
> > 
> > Search "BPF_MAP_TYPE_SK_STORAGE" under the selftests/bpf for other examples.
> > 
> > It seems there is already a "bpf_get_current_comm()" helper which
> > could be used to initialize the task comm string in the bpf sk storage.
> > 
> > btw, bpf-next is still closed.
> 
> 
> I have rewrite my code according to your suggestion.  In general,it works as designed.
> 
> 
> But the task comm string got from "bpf_get_current_comm()" helper is belong to specific thread.
> It is not a obvious label for skb tracing. More reasonable tracing key is the task comm of process
> which this skb belongs.
>  
> It seems a new bpf helper is still needed.
May be.  It is not clear to me whether it is better to account this skb
to its process or to its thread.  I think this depends on the
use-case/assumption.

If bpf_get_current_comm() does not get what you need,
then another helper may be added to get the process comm.
This new helper may be useful for other use cases also.

btw, Have your thought about tracing at the sendmsg time?
e.g. tcp_sendmsg()?
