Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5656263C54
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 07:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgIJFND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 01:13:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36230 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbgIJFNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 01:13:00 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08A59CAm007843;
        Wed, 9 Sep 2020 22:12:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=eD+Muggb3jGelHPuMbgSibqCouyF7MGW733RkYp0tR8=;
 b=ZqRCRDUqofUEXsR7kz7x+8s1dlmX1TRPy84ai0mWnKImq3UJNhAA0zKH+9AHXbM5XxID
 yNWwWjKrSum3AgLF0H6LttQFjDSDPrRXjCIYWUiMX9s5id36yq3DH2um5EsqSqqcQ5hV
 b/DJGjS7TGjnc3x7wVpoocF/FlQRmYmv7V4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33c8dwp3aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Sep 2020 22:12:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Sep 2020 22:12:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzwaK+rijplWzwoBQ909I1b3ZXmHq2UudLneS9QbH1TvFFgjPPKeRbA0o1fj0u8XagsHMK2RoaO2YybZLPa0icmeFxerXIHps/lNcsck9umpvWo+imWc6RbkqvW2Am2/VfmMhv6A670vCwR+Jky8Ag/g7AH/EkJeE4jQ75xkhNAfOevKwl95tqDN+jQmCZ21Ugbpa+tm6Ct/yJH8hnm1YoNvmBEpilvRwRC1Q84sdHNGqYdUo2kAAJW2J3C6wvcjze1HVaPGcqV+83xlrVjX1vTaSYaGxQf08MgpzG1gaO8Ss88iXoVv8KGdRkWNOGZ05bxW1hWUPxMcMuXBz1mF6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eD+Muggb3jGelHPuMbgSibqCouyF7MGW733RkYp0tR8=;
 b=QS6MnnTQ1tgyN1ey0OzZsj4zsQH6i59IXkaPSSzoe2s51kVLC2/xeN+LTFXUqndTW0eYrbouScUu/0gLEBiboihfM04AxqjJv7/ijMvuq707q+OcUOu3iVzAubE3tpqz8jQkm9tEewwUN7UlZtjtvECeIAA31x9QfUHsHRKyDZZ3Mszq51dtEUBAntS6qc+nPd1hqXIpcqNWqJgnpfn+uSGaxsprbBKLwFIKNQfzhFFSLM+KQT6Wq2WCk3D7TV43Nd5CZDYs6YI+K/p5UFOlMe0tS/znY3rg5b9TIWTJ68yI2PuYGAF0W3k78ueqzfl2UgDcA9e3HiaDjKheBr7BcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eD+Muggb3jGelHPuMbgSibqCouyF7MGW733RkYp0tR8=;
 b=ZL4jB7r5742THf1GuCxr+wBoCLzPvMF6Yp+Bm4Wc6UBH/gpXK2fxHwTpAOgn9w6BiSfOp7kQ47sALRfAUo8pkSNtSB11AjQX+Yh7Hxrsh9eQXqOJNFcZ2qY5Mv9CmYHyIl9LdZBFtO98lTFN5LTab6Av6RvSON0b87EtdQk0Syc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3094.namprd15.prod.outlook.com (2603:10b6:a03:ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 05:12:54 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3370.016; Thu, 10 Sep 2020
 05:12:54 +0000
Date:   Wed, 9 Sep 2020 22:12:47 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Neal Cardwell <ncardwell@google.com>
CC:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] tcp: increase flexibility of EBPF
 congestion control initialization
Message-ID: <20200910051247.d4ai34fc2pmqmk3i@kafai-mbp.dhcp.thefacebook.com>
References: <20200909181556.2945496-1-ncardwell@google.com>
 <20200910003606.fvuupr56as4uknxn@kafai-mbp.dhcp.thefacebook.com>
 <CADVnQymvJTusK+UohmpzJL1_8NX+MiYagkzA5Jkvj0Ywched-w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVnQymvJTusK+UohmpzJL1_8NX+MiYagkzA5Jkvj0Ywched-w@mail.gmail.com>
X-ClientProxiedBy: MWHPR14CA0064.namprd14.prod.outlook.com
 (2603:10b6:300:81::26) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:598a) by MWHPR14CA0064.namprd14.prod.outlook.com (2603:10b6:300:81::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 10 Sep 2020 05:12:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:598a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44391970-9940-46c6-ccb4-08d855482bec
X-MS-TrafficTypeDiagnostic: BYAPR15MB3094:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3094086580D93DF0EDCDAB0AD5270@BYAPR15MB3094.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y0xVDQqcyjuBkrq5MFeomVtHvXYIXrClQhLmi0apRTK00pPpwKk95EVvXBWeZ5JFzuwAG/thpSWe1xQ01r9isKxGju7KMu/gUvm35NGQvkg5LAGF2PsTzhmpXpvqQ4/Cw5DF3I0TOApZNjVbpuiNq5kL6ANYBAGVyKMkZrNV/Xn65cZkj2BnrL4tHjNaGaNjoMI4DC4/1eRnmYj2HrDx5296E4bvOOnuvC49Y89uQkztZJCVZQWZ87dGyKdOAOgAfMYHpmNx5Z5xafKATqkyFcS/3nt3hK9mpiIiN2j/MDNVbAtZPApVGCDPS4RXlUXhYXGzKTZxxxrYC6dfUDIjAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(376002)(346002)(66556008)(6666004)(86362001)(66946007)(8676002)(1076003)(6916009)(8936002)(66476007)(52116002)(7696005)(16526019)(478600001)(186003)(6506007)(53546011)(2906002)(9686003)(55016002)(5660300002)(316002)(54906003)(83380400001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: T/okjKpN63krkhV1JYYCutSjSpDjZM68do8u2+CJcGd0DpytFRRTpNqjiswKEHLhhQ7TxpQta1B+lcxsHR1j+djWzIQtnVAsmHpGellLYIiB50ER9ykNvje5SoULC4FW9zqBFkf6O67SuLg8bZxj+ss7CJAbLuZaAJWuV/y71SBKqrfAODphg7yLBpjxtV+DhvsUwrG8lLOCs3c7ZKaJmYLraFkb1QDz4w0/ui4BJUgtj19AW+46iYeUuRDAHkxHEe47p+sWqcPpjNnxlg6NJcm6LiSB0ECO24n6rrayjDM3wcC91iMTlB6GqUZ4o+XASBNvuaP/+RyuDQXtES1pDPMcIY6kuOcKKEpF0TPvk3Hw1yFirOg9LDUtrY1RJHtc+nUP5iO+lOAfuTe6AvT3RgyKMQOKrlz2DQ0M1qHjftcDdpViALy7zleQQrg7gMV6p05GyVIsN3dw0dtZTN/dt70aiA5uM1X/zOTW3mKmWkfXmuEwzJliVT0ZdzlmzWD/hz4T8sWUm2QxfFT+vsbU49GVj75i6vv6KyOIRJwfmPAhpxLBH1juqgngR9g5XPnbyUu4p0GlFOPCX4rVx6IAW9w6ND1+E2SZqShLj4zmwQ96NI9Ln2/7zGWYiPhYxn0mTuL9nqCZA5Ww1Ly77aCze12uBTy9zf0A+4rcVlMLEmk=
X-MS-Exchange-CrossTenant-Network-Message-Id: 44391970-9940-46c6-ccb4-08d855482bec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 05:12:53.9948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMcA5QuvxZs1dPj027TKLMKByFwePMNwYSDLb913GoY34ZrSA3lc2/+u4CYRFcGy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3094
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_01:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 11:21:50PM -0400, Neal Cardwell wrote:
> On Wed, Sep 9, 2020 at 8:36 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Wed, Sep 09, 2020 at 02:15:52PM -0400, Neal Cardwell wrote:
> > > This patch series reorganizes TCP congestion control initialization so that if
> > > EBPF code called by tcp_init_transfer() sets the congestion control algorithm
> > > by calling setsockopt(TCP_CONGESTION) then the TCP stack initializes the
> > > congestion control module immediately, instead of having tcp_init_transfer()
> > > later initialize the congestion control module.
> > >
> > > This increases flexibility for the EBPF code that runs at connection
> > > establishment time, and simplifies the code.
> > >
> > > This has the following benefits:
> > >
> > > (1) This allows CC module customizations made by the EBPF called in
> > >     tcp_init_transfer() to persist, and not be wiped out by a later
> > >     call to tcp_init_congestion_control() in tcp_init_transfer().
> > >
> > > (2) Does not flip the order of EBPF and CC init, to avoid causing bugs
> > >     for existing code upstream that depends on the current order.
> > >
> > > (3) Does not cause 2 initializations for for CC in the case where the
> > >     EBPF called in tcp_init_transfer() wants to set the CC to a new CC
> > >     algorithm.
> > >
> > > (4) Allows follow-on simplifications to the code in net/core/filter.c
> > >     and net/ipv4/tcp_cong.c, which currently both have some complexity
> > >     to special-case CC initialization to avoid double CC
> > >     initialization if EBPF sets the CC.
> > Thanks for this work.  Only have one nit in patch 3 for consideration.
> >
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> 
> Thanks for the review! I like your suggestion in patch 3 to further
> simplify the code. Do you mind submitting your idea for a follow-on
> clean-up/refactor as a separate follow-on commit?
Sure. will do.
