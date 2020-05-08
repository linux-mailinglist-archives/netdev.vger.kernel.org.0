Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478951CB61D
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgEHRe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:34:56 -0400
Received: from mail-eopbgr60066.outbound.protection.outlook.com ([40.107.6.66]:37095
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726807AbgEHRez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 13:34:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQQG3+SzwMb+qlfQDg1OgnJZN+mOnKTiYGV0Conm9KgQ3doTVhVjMOFiq0foTNKHQqvdrTF9U4pYhUdIibze5XqBznx0NdDQFfg8AcnZYuiRtkRrzIzUU5RPtZVD/V7gUEGuv0gMF13IJF4BDyRdO8FazjQZT1G3SVDQvsCvj2LsQ4pnSebXoXGgRFuwg8z9bfPFW3TgUIRgKiSRVaXx7IGReQsrbrKsKreYIoDieOc1/95aPkbw7VfjnAsLnFf5W6kSG0fZsxYhgzELK/FBJ284sGUv+jRyZizuo1XulaC/s+OqO9W/f50u85TsiKUkmbtn9g+BbK3CYcCqHinYAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8GbNR8CL1UIDcfqSdoLRyVZ7wA2l2fH5scp9/IFb34=;
 b=J0H9TSfswex40mkpJ3in5n0lbSbnTwQNuktqfGd6PiXOlsikRP0zkXrZNYSmDZ6btx4l0rT/3eFzQqzzo/PNBytzTPsSGT/inGgwosX5d9vC94mFOFzAzGFiao9Oe8y030G92wMtD9lLZbWoA7GfgrV33K3XPrpIVX9v0rM9gG3Hl8Ewkj9+CCIpiJ195BmxIQqu6LcvZipinPuV6RJZkaxbnaVoxaE6lbIF0cc4z6ZSJQv8qbQSKWwj1auHbt1Igiv6NRVlPaAKkYpIhxmRJHQcmcqvdBnvKBWEISjYXU56DCivZ3BJJh5JUcMprQPdmftD/ZaM8BH8BKS1TVj4vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8GbNR8CL1UIDcfqSdoLRyVZ7wA2l2fH5scp9/IFb34=;
 b=FlXQ6emRzNYbLjJD+9UFL8dzCRbjHu0dVV6D8V8PDXfZdrDXNlk5GLJbin+BUCbGAMB8pBatGc5LvNH2vt89a9jPnl3LrXXSBpslV2KnM5NNY8b9zlFFnPQmFl8Fm8WTCUiDP3pMdK6vXeA8+hx+n+wczSaj6AiqgHEOIMPwxBU=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6632.eurprd05.prod.outlook.com (2603:10a6:20b:136::12)
 by AM7PR05MB6881.eurprd05.prod.outlook.com (2603:10a6:20b:1a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 8 May
 2020 17:34:51 +0000
Received: from AM7PR05MB6632.eurprd05.prod.outlook.com
 ([fe80::94da:ac7a:611:781f]) by AM7PR05MB6632.eurprd05.prod.outlook.com
 ([fe80::94da:ac7a:611:781f%9]) with mapi id 15.20.2958.030; Fri, 8 May 2020
 17:34:51 +0000
Subject: Re: [PATCH bpf-next 10/14] mlx5, xsk: migrate to new
 MEM_TYPE_XSK_BUFF_POOL
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
 <20200507104252.544114-11-bjorn.topel@gmail.com>
 <40eb57c7-9c47-87dc-bda9-5a1729352c43@mellanox.com>
 <3c42954a-8bb3-85b1-8740-a096b0a76a98@intel.com>
 <cf65cc80-f16a-5b76-5577-57c55e952a52@mellanox.com>
 <CAJ+HfNiU8jyNMC1VMCgqGqz76Q8G1Pui09==TO8Qi73Y_2xViQ@mail.gmail.com>
 <CAJ+HfNiBuDWX77PbR4ZPR_vuUyOTLA5MOGfyQrGO3EtQC1WwJQ@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <4c627f32-bbe6-21ff-f06f-c151093ec0e8@mellanox.com>
Date:   Fri, 8 May 2020 20:34:46 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <CAJ+HfNiBuDWX77PbR4ZPR_vuUyOTLA5MOGfyQrGO3EtQC1WwJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0002.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::12) To AM7PR05MB6632.eurprd05.prod.outlook.com
 (2603:10a6:20b:136::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by BE0P281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:a::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Fri, 8 May 2020 17:34:50 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 08e8abb3-cecb-45ff-9b0e-08d7f3761cdc
X-MS-TrafficTypeDiagnostic: AM7PR05MB6881:
X-Microsoft-Antispam-PRVS: <AM7PR05MB688182E295FEB8D81BDEA62BD1A20@AM7PR05MB6881.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 039735BC4E
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8L0ZmEO9/D3xo0a7SXxvhFMck3czwEZqXxt7lc2Z6o2mJwLRXXnNxdlGqZP0PULpl00agNrOrx1MLCSl7PBSSCXN2De8nSaUC3BdgqZHRY+fPtELetgQaLwqMtN0c9bWu55ZPjLBWg0SEHC2/QB398W7M6YwdHerjMmBzAEmio3cDjOsuoVEOT42I4nn9mVr7VRpaKn9jL0w4vcijLqyg6eBYVADRDUPdnu0CXSreiLoFI86DSdIQexah4cA3VnhC4B8p11fQHdooktodEV8b7Zir5sdjSb+VdP+2y31oa2c82+OBhXW/SV3Osi6koeED9/lNeNPGouoV9/KPT+NLfIE53BIISw55GRahkWe2ZBgtfsHVb5vQZTWZ4ANB5mqn3NGPgF/NIn6pgl5u3HVNsrorTshzuE8VoD2thdZuX9esJceWmOT1hJ/x9wrklbauUwxtRr33h59NnttV8rqq5A5lEVNPEZ09jBtl8O03YLCDuR5THN7J2Kq01o2nBIvL/RJ/0LMzcOlm2syvGtUuE/ImZYkQ+L3spd0h5NNMb582H05OS9/qwcPXX5peI1a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6632.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(33430700001)(52116002)(31696002)(478600001)(2616005)(36756003)(66476007)(8936002)(316002)(16576012)(66556008)(83300400001)(83280400001)(33440700001)(54906003)(83310400001)(83320400001)(83290400001)(956004)(6666004)(7416002)(5660300002)(86362001)(4326008)(55236004)(6486002)(66946007)(16526019)(2906002)(6916009)(4744005)(31686004)(8676002)(186003)(53546011)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UbwHCj9lFPCw1/cznSlIV3dv6nteOtXf8KasvFxRu/v8zOEFuoQhGKuf+wO47dj3Jt5PvknVjLop4PCCYQnfwCZXfb9ighm+yuWRvUg1645OWx2HHtqQUdYCy7oxzZfwycqF39XQJzisQN0HY4HOWunGc0yKJxKjOBZ8AXw3ZcYd/PS5SM59w2gDZIFzc18f9cs+f7LEv5ZAHqgnDsMECqN9V/n7d7ubRymiwWXPEL4u8wljxBn46czDV6betGAUSeX5VDD4XuPxhlYgYsyFX+TKRGdBRiAvXTWOBY1DiXK+En+gQdseMW3w+Fj97CY/DujkByb9gRaK71FslE/LKNJ9xglqsNRTycvFFTmq/w6qAEuF18P8Sc9RtTydUSH90FlAs4ek2OQzBBRnFoi0z+VKM2so8XRjnciE4NnACZt8gczcX+MnWqZOIAfjodHnK+gUaKvIAdIVCHjc8d1tGqelPMzYb/fJf3xsU08MZLbx4Z0ZFbughym+nOrLez4f
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08e8abb3-cecb-45ff-9b0e-08d7f3761cdc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2020 17:34:51.3578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJc36IBkr+eogg8HATLHcaii5iM2LdBqlCUCMZn7aTxelYj76GvPmDU7nLzszd1zVis6PmdabDNOjKCkHLZIvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6881
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-08 16:14, Björn Töpel wrote:
> On Fri, 8 May 2020 at 15:08, Björn Töpel <bjorn.topel@gmail.com> wrote:
>>
>> On Fri, 8 May 2020 at 15:01, Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>>>
> []
>>
>> All zeros hints that you're probably putting in the wrong DMA address somewhere.
>>
> 
> Hmm, I can't see that you're using xsk_buff_xdp_get_dma() anywhere in
> the code. Probably it?

You are right, thanks, it was indeed missing. However, adding it was not 
enough, I still get zeros, will continue investigating on Monday.

> 
> Björn
> 

