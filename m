Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F3044DB91
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 19:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhKKS2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 13:28:12 -0500
Received: from esa5.hc3370-68.iphmx.com ([216.71.155.168]:5401 "EHLO
        esa5.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbhKKS2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 13:28:11 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2021 13:28:11 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1636655121;
  h=to:cc:references:from:subject:message-id:date:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rhNHQBIyHAaFCpSpiyZnlAz6ft1JYYvfl5ikm2JvxJg=;
  b=Uf6F4xeMPRb3b+PBF8fOFsMLTzcfpvU4oR/j3nwM/z7TBVvPlE5ukZ8y
   EpKiBXHQi5ZYC7a+ckaJ30a/XjARlSxLqaFkc7IHYY+78oWPPlSyDjMt4
   1+NzAkSdwdoiBIZtL9f+0JjwOEN4dVPbmUpVy7dHve+ZBVO1Ve1lZWIKB
   I=;
Authentication-Results: esa5.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
IronPort-SDR: AneOQckzRA6a3M63ykwM53Byg6wCue1PH5f1qZrRuf9y1D7EKgdJKuNBKO0ALS1ItJ678YZUbE
 wM5jlWIJ4HZbe/zn9ITxU3wvp2YoQoBnB3zCYf0FrdQOgmqt8V+zFQw49MZ+reeByDIChzBbsD
 IpZkSLpy5AqQOH0YXK0SkzQWh3fGSszyK62e6tZfBlxk+bwExibb58DObLx0rpchScxTkORrjS
 /j2vMy7Sq2RmjT6OELbozjsNphidHXGXrvFSzHe/KXEY8Ejd5ozSaro4QgPzamtLoOR1SyVzGF
 yAVhZyMwFyqQ9bz2K0EuT08Z
X-SBRS: 5.1
X-MesageID: 57157476
X-Ironport-Server: esa5.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:4Xon7qwfnBpEMdTJjBJ6t+duwCrEfRIJ4+MujC+fZmUNrF6WrkUFy
 2ocDDzVbPzfZGL3e9AjbN/goUoEvMDVnIJjTgo9ryAxQypGp/SeCIXCJC8cHc8zwu4v7q5Dx
 59DAjUVBJlsFhcwnvopW1TYhSEUOZugH9IQM8aZfHAuLeNYYH1500s6wrdg2tcAbeWRWGthh
 /uj+6UzB3f9s9JEGjp8B3Wr8U4HUFza4Vv0j3RmDRx5lAa2e0o9VfrzEZqZPXrgKrS4K8bhL
 wr1IBNVyUuCl/slIovNfr8W6STmSJaKVeSFoiI+t6RPHnGuD8H9u0o2HKN0VKtZt9mGt45p4
 oxc7JWycwMoH/eQ3+MwdzlkOhgraMWq+JefSZS+mcmazkmAeHrw2fR+SkoxOOX0+M4uXzsIr
 6ZBbmlQMFbT3Ipaw5riIgVoru0lINPmI8U0vXZ4wCuCJf0nXYrCU+PB4towMDIY258XQKmCO
 JRxhTxHSAjKRiwRFA0tF8gFmNb23lDmNBZApwfAzUYwyzeKl1EguFT3C/LYYN2BA8lIm0+Kq
 37u8GHwAxVcP9uaoRKJ+2yhg8fDlD32XYYVGqH+8PN26HWeynEWAQ8bSXO0pv62jkP4UNVaQ
 2QM9zYjt7oa9UqlVNDxUhS05nmesXY0WMdaGsU55RuLx66S5ByWbkANSjNRYdoqudVwSSE73
 VyhkNbgBDgpu7qQIVqU87zF8xupIyMba2kPeUcsSwYZ79T9iJ88gwiJTdt5FqOxyNrvFlnY0
 2DUhCsznbMeiYgMzarTwLzcq2vy/N6TFFdzv1iJGDL+hu9kWGK7T9KwwwHKtP9CFoKYbwPd+
 38pv+iixdlbWPlhixexaOkKGbio4dOMPzvdnUNjEvEdyti9x5KwVdsOuW8jfS+FJu5BIGa0O
 xGL5Wu98bcKZCPyBZKbdb5dHCjDIULIMd3+Hs7ZYdNVCnSaXF/WpXo+DaJ8Mo2EraTNrU3dE
 cvEGSpPJSxDYUiC8NZQb75MuVPM7npurV4/vbihk3yaPUO2PRZ5s4stPlqUdfwe56iZugjT+
 Ns3H5LUkEsCDryhMnSIrtF7wbU2wZ4TXMGeRyt/LL7rH+abMDt5V6+5LU0JJ+SJYJi5Zs+Xp
 yrgCye0OXL0hGHdKBXiV5yQQOiHYHqLllpiZXZEFQ/xgxALON/zhI9CJ8pfVeR2r4RLkK8rJ
 8Tpju3dW5yjvBycoG9DBXQ8xaQ/HCmWafWmY3D4PWNhJsE4HGQkOLbMJ2PSycXHNQLu3eMWq
 Ly8zALLB50FQgVpFsHNb/yziVi2uBAgdChaBiMk+/FfJxfh9pZEMSv0gqNlKs0AM0yblDCby
 xyXEVETouyU+90599zAhKalqYa1ErQhQhoGTjeDtbvmZzPH+meDwJNbVLradz7qS26pqr6pY
 v9Yzq+gPaRfzkpKqYd1D51i0bk6u4n0v7Zfwwk9RCfLYl2nB6lOOH6D2cUT5KRByqUA4Vm9W
 16V+8kcMrKMYZu3HFkULQsjT+KCyfBLxWWCsaVreB33vXYl8qCGXENeOwi3pBZcdLYlYpk4x
 eoBudIN71DtgBQdLdvb3Dtf8H6BLyJcXvx/5I0aGoLiliEi1kpGPc7HEibz7ZyCN4dMP00tL
 mPGjabOne0BlE/Lcn51HnnRx+tNw58JvUkSnlMFIl2InPvDh+M2g0INoWhmEFwNw0UVyf93N
 0hqK1ZxdPeH8DpfjcReW3yhRlNaDxqD902tk1YEmQU1laVzurAh+IHlBduwwQ==
IronPort-HdrOrdr: A9a23:FGZkgKMroaSxIsBcT1H155DYdb4zR+YMi2TDiHofdfUFSKClfp
 6V8cjztSWUtN4QMEtQ/OxoS5PwPk80kqQFnbX5XI3SITUO3VHHEGgM1/qb/9SNIVyYygcZ79
 YbT0EcMqyBMbEZt7eC3ODQKb9Jq7PmgcPY9ts2jU0dKT2CA5sQnjuRYTzrdHGeKjM2Z6bRWK
 Dsnfau8FGbCAoqh4mAdzQ4dtmGg+eOuIPtYBYACRJiwA6SjQmw4Lq/NxSDxB8RXx5G3L9nqA
 H+4kPEz5Tml8v+5g7X1mfV4ZgTsNz9yuFbDMjJrsQOMD3jhiuheYwkcbyfuzIepv2p9T8R4Z
 XxiiZlG/42x2Laf2mzrxeo8w780Aw243un8lOciWuLm72weBsKT+56wa5JeBrQ7EQt+Ptm1r
 hQ4m6fv51LSTvdgSXU/bHzJlFXv3vxhUBnvf8YjnRZX4dbQqRWt5Yj8ERcF4pFND7m6bogDP
 JlAKjnlbdrmGuhHjLkV1RUsZmRtixZJGbDfqFCgL3a79FupgE786NCr/Zv2Uvp9/oGOtB5Dq
 r/Q+JVfYp1P7orhJRGdZE8qPuMex7wqC33QRavyHTcZeo60iH22tTKCItc3pDcRHVP9upqpK
 j8
X-IronPort-AV: E=Sophos;i="5.87,226,1631592000"; 
   d="scan'208";a="57157476"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dm5YrdeAlCu+qFMxCBtUKFqhBWg6DF1IXxDtWLZKIQZIRmsTrKFyneh+cY22KK6NUcUwzMYJpR7rXCxET1tXDXvg+B80orMfBkoIOL5SpHGPJyw1ggUxxR1avvURZVXGdtXQKPrP2hZkYoDz2YpGRV83fUOLGxs9Axct/fzBbId3a6iXnzMQfLC4SRU5rjs6R6xgUwNdP6MMbEVVpuv5Z4iEagAbp9se+xNPKVQ8Xwbl3aBpMPdu5cHBfq2JRYKWRDxO19RkgKGQTryGXRyWFLchMKoUDh7sXwInHURdzec8F0g33KjNPfYe/yecAbu8VS1MnczH2bvHYftHc3bJiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzK34Kbj9LnWrDCuTd1Y/DTJIhk9UuTOomU/6tFaEE8=;
 b=FZaJ00ATG8CA5SCvfX4DAZwP9SV0TN7UMvw1uyRZGtwAbKOsXTYJmTYYS/KovfuHBkPn3FLwa09Mi/GQVvWbLF2fzelaUTHTLsZ4FIUcDHyjTaZQM1/I9+L5heP6ygGMk7omK+RqCoEBY0XAXlXX39n2G1AB+Vlpq2FmahaSWV7abW5E0RE9SFMDlFWBk2GnO6A/4njBKWkPm/vBmLAN8VJ8WbZZruppZPAaRDWz5kOE6Ul6wTvgNEP/wsGyzHh1SGzvvXX7Aw8ZFntmWqzDM91ct7Dt1N+dMKR0zmxBemUwBRqC/adA0Hj45MHZkxRj4rYOk3GFG9ecsAQfsDR6Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzK34Kbj9LnWrDCuTd1Y/DTJIhk9UuTOomU/6tFaEE8=;
 b=w6FV3zw8V0lp/SsVCTNtT0x8D2HKDR+XKN3XxrL2M1edi+rH0DbUywxJ4SZ6hlHUm9CuSsrmZakUCn/PCyxH9vROmFyvRdIbQmbGaWLPHkgLiIzFhznsD2giX5XAtQjXbN+Fo0sp8SwRpJHlQrskp8AuC37NVk9oTN3r07Xd0mg=
To:     Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, <x86@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>, <amc96@srcf.net>
References: <20211111065322.1261275-1-eric.dumazet@gmail.com>
 <YYzd+zdzqUM5/ZKL@hirez.programming.kicks-ass.net>
 <YYzl8/7N+Tv/j0RV@hirez.programming.kicks-ass.net>
 <CANn89i+qjOpL9eYj=F2Mg-rLduQob4tOZcEUZeB5v0Zz3p6Qqw@mail.gmail.com>
 <CANn89i+Y6OXdKccgM6+gC-2giJFcOrMfraG7ofCfKXmjsfMPJQ@mail.gmail.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [RFC] x86/csum: rewrite csum_partial()
Message-ID: <2b36e547-f080-a1ee-f0f0-a9e5fe1e4693@citrix.com>
Date:   Thu, 11 Nov 2021 18:17:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <CANn89i+Y6OXdKccgM6+gC-2giJFcOrMfraG7ofCfKXmjsfMPJQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-ClientProxiedBy: LO4P123CA0359.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::22) To BYAPR03MB3623.namprd03.prod.outlook.com
 (2603:10b6:a02:aa::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8e968b0-96c4-47ab-3e65-08d9a53f99f7
X-MS-TrafficTypeDiagnostic: BYAPR03MB4741:
X-Microsoft-Antispam-PRVS: <BYAPR03MB47419115A152682824FC6558BA949@BYAPR03MB4741.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y0VEYwwciZMWIBt0fRGR3zl/Q/wId3NEhedb30P5SmF8dhRbOb+dx8g/3gOMxfu5NpfIMmUQnGqh3WMRkfFNvPLGyvINTgcyHc/+74HX08gvjeWyaWcV7NFXkLnZ5EJ4qwS0FUAMOYjaz07LNbIOMjEN5T1RTQE1dsTofAz6crso1b06x5rcfsPr3zMO/MBYToW16Dq9GqD6bsaYjkxEz4L1wTS+AZyCvLFkvkJxYBl4w16vx/FW8abS13J6uynoNvuNtnlhKkW8pXlC1xQrbyGdSmNTW/5DT9mDskvAszHdZplRqqMDjTL9dPCl1nfoyYzfEVtHUW9bmnTbUba+F40SHwdqNnld2ckSuzE0BBmqCf9R9F4eTszpF0LkBbgW6Ij97ttPheJXKhBXQmxy1oHcqR3z19SnHeyweBwawf9rVHRmt4z/Q3WoGKybgJVd8zElM6trTZ0WP/aUdd+L81qWKrlGG6O2TMTwuFJGBBieyTClD8fTlN5LcuywJ+ama1kMpUvw4Z85+B36XYS0oqJkHkjbapsZDtuHFjgy7gCvQn5F6LROGrDOwOruAAivUhl1sAK/xsNTpoDYGvKQ+B7s4w15xVlS1MErOL04iIWQ42W3BybRSTeCck22FOlkmDEtO4I5bMsdwdRV9B9iZuPFqP7zGUWg5iH/UQ+9FcPzCjwCiP7yWNjo2/fw3Zz5EjWo4aJYa2GlIyyT4oE4Xwz77iRC2k6Ap1hH23s5pNb1mTLanR2gG44DQyLOJXnw+L8R5efZ/T1nNOZoybXEWDlbMyvKRaMLDYq4gasq61COa7eSa4dX7cM7Zm32Dn8h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(5660300002)(508600001)(8676002)(2616005)(186003)(4326008)(66946007)(86362001)(956004)(83380400001)(36756003)(6486002)(8936002)(31686004)(38100700002)(16576012)(53546011)(66476007)(54906003)(316002)(66556008)(6666004)(110136005)(31696002)(26005)(966005)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDROaVVtdkxPN0pjaTlhN3cxUXgwTm1lSW1pU05vOFNFQkhwa0JWQnNIM1VM?=
 =?utf-8?B?N0VwUjNzcmQ3K3RubHVCRHBtUFpQUHRjTkdYSE9LN2hKYnBCaGtseElTOEFZ?=
 =?utf-8?B?RG9mK09LSitLMWJkMzJhM05YMkdDSmtiZmJKYmd1Rkl0Sk53MXU5anNwa1Fi?=
 =?utf-8?B?TUwwS3ZGclJiUnhzQ2IzdzdBRVRETWk1Z0tYeEowbUhHc2lnMTJYcFNxeDVz?=
 =?utf-8?B?QkxWcHAvNUJVMStwR0VJdTlldXBCTlF1a0pMbUJxK2x6K1pxdEgvZDYzaTJC?=
 =?utf-8?B?RzE4d1pXczBCQkxKUEM2ZlRQKzZpd3padWx5UmpDWVBRa2o4MVg1L0dnYjVi?=
 =?utf-8?B?N1JYWE0yd0l6OEh4dVE0R0ErWm54S1hmZUNpdWg1eVN5eUxENThheU4xK0JM?=
 =?utf-8?B?QTFMSm9QRnF5dnQ5Z1VNaFJnMEpScTRibnBtNDBjcU50ZkVYcXJLVEZlNDBp?=
 =?utf-8?B?Q0N4cnpuVTRJRFZZZjNQYWdGL1VQc2ZVSndJUEZwcGUzdWNBY1RuNHlNNzRH?=
 =?utf-8?B?bVBMK293S3lGelAvWjBLaUFYVllPeU5uTlFiZHUrVmIwdndPWWpvZTNzajQ1?=
 =?utf-8?B?bWJkMm53K04rWWJDdmhLTElHLzhPQnpKQkY2OVhrcHZYeFhZQnN2U0VZeTZt?=
 =?utf-8?B?RDkvb2psdGZxQjZNTjlPWkk0d25mMmNUVkcrS2JqSEpTSXFuWTBUdVY3TTYz?=
 =?utf-8?B?VHhHaDRNR1VKYWMrM0ZKUGlVUURoaFFTZ0NtdlE1cklld1RWN0k5UU9OdUpk?=
 =?utf-8?B?dkc5LysyUjh4SUFsRnM4MEhuR1hOTmZlcW5Ud2hVYzFVbkdhc005dTdnNjFi?=
 =?utf-8?B?cGpnWUJ2RllCMWMxT2I4R253bm9ueFVmV29yLzhuYndvUVlmS0dpTzZ4ZklS?=
 =?utf-8?B?UktSbEU1WDlOM2VGNHhZUExJb2JyM2VlOFc3UDVwbzZmWmRvZ0FySlZKYVRO?=
 =?utf-8?B?dTNIL2EzRkU1WEZ5bFYxeWNLUWNGQTFrTkZpem12TmM5c2p6cWgrRGlCQUc2?=
 =?utf-8?B?YUtlb1l5dnBUNCtQNUNoMDE3WUg1MDFERXdyRTBmMlZoMUhUTU9hck5ETFox?=
 =?utf-8?B?eVgxSG9KeHNuWkhhSmt4THRmYW9SNTlFVFRBWW5EU1NTM2tqb0JETGUreEVp?=
 =?utf-8?B?NkpkV1pJcExLZk1lcVZBZGtsNlNRNDh4Y1dNMVNKSWZydGZtVlM4dFVHUHVx?=
 =?utf-8?B?aGpLUE9XMUp4amNpRXdOdzN1SnJPMGNUQ0xaTkRYa3RnVXI0QUhmZjlWRGtt?=
 =?utf-8?B?RkUvelczTXUxNE5JbTJ3WnN0TjdUa2p2WW14NVFQS3daWnZ4KzRuNkMwb0cv?=
 =?utf-8?B?SldFT2FNOEprVFZBN0hvaWYrL3Y5S1N3a1Rzei93Ynl2VklSOEhRRjVDUDZY?=
 =?utf-8?B?QXRvd2JvUTRQU01kb3RFTTBrQXlERlQvSTB0S0pWMDhBRGhHVDlseUl6Rkxm?=
 =?utf-8?B?UjFYNWN1WkRPaXUxOVlEVVUzSmdRejhnVW1BMm1mWHk3T2tjK0NTM0RISmdH?=
 =?utf-8?B?VUkxbTY3cW9EaDdOOHZDUTRLUzdGVnlubkxqd2p3YUZXNE1EcDZFckVpQkt3?=
 =?utf-8?B?dENWOVl5VWtJQlM2VlMvYXhLa0YycCtzczNtcWpobERFdkdFYUREN0FyRjk4?=
 =?utf-8?B?RUtHMXBDMmFmZjZBb21uYTFQaGVoL09DcDRLdWlrbjI2c3E5U1JwUFhscDFK?=
 =?utf-8?B?cnF0dEk1U1d5UFoxdnZtMHlTSnpTaHNVaEhUWFdxRlRMeWJIS0I0WmNIS1lP?=
 =?utf-8?B?SWx1RzJZaTFHb1IrOE4yOTlwR3NNTmtoWlBuNjVFTzFVT2lPeUxTb0tieVcv?=
 =?utf-8?B?L0J4ZklCUk94RFh3TlhZMEVWVEExNGlQQWt3a01PUVZ3djQyaGZCSVRteWRX?=
 =?utf-8?B?a3p5MFFsWVBVblVHUVFSZzBiRTNrVUNMWGVrUUlSeXJLZHVuUlYrcmdCYWdP?=
 =?utf-8?B?bHRaSVdoZEgrQ0lER1k4OC9RaU5Dai8vcGdRc3lMbjhhMmE5ZXdWR0h4cEt4?=
 =?utf-8?B?NlR5aWpHV0dyQUQvNGNTQXozNVgyTGJlREx3QXhSd05iY1hQUVhJaEJtNGo5?=
 =?utf-8?B?dXhlVC9SVldMeklDTnBYN3U3THhncmFFUmw2UVNZVjBvRXhseUtzY1dQVGo0?=
 =?utf-8?B?eTEvL1ZZQ2M1eFlTZEJNY1BTTXplc0R2ZmRiR3o1TklweWlHWWVxUHJ1eXpH?=
 =?utf-8?B?TDJxbjJaa1QxK1RUUEgrM05nYndDRWZ5S3NkK01UbFF1MWMxeWxqU2crWi9I?=
 =?utf-8?B?SXBKNllWeUV4Ym1jUmFJZXV3b2VBPT0=?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a8e968b0-96c4-47ab-3e65-08d9a53f99f7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 18:18:03.8253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ZJLYxowwJPl/JBiXJSPhwjwy//BdEnI5THZCYsq1PGwIRmFi3DNNkRYA6lct2ifW2WZXd55TXLCm7h8tGITqJ5GncVukvrv4juCgs1ztSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4741
X-OriginatorOrg: citrix.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2021 16:52, Eric Dumazet wrote:
> On Thu, Nov 11, 2021 at 8:02 AM Eric Dumazet <edumazet@google.com> wrote:
>> Thanks Peter !
>>
>> This is more or less the first version I wrote. (I was doing tests for
>> (len & 32), (len & 16) .. to not have to update len in these blocks.
>>
>> Then, I tried to add an inline version, a la ip_fast_csum() but for IPv6=
.
>>
>> Then I came up with the version I sent, for some reason my .config had
>> temporarily disabled CONFIG_RETPOLINE,
>> thanks for reminding me this !
>>
>> I also missed this warning anyway :
>> arch/x86/lib/csum-partial_64.o: warning: objtool: csum_partial()+0x2f:
>> unannotated intra-function call
>>
>> I will spend a bit more time on this before sending a V2, thanks again !
> BTW, I could not understand why :
>
>                result =3D add32_with_carry(result, *(u32 *)buff);
>
> generates this code :
>
>  123: 41 8b 09              mov    (%r9),%ecx
>  126: 89 4d f8              mov    %ecx,-0x8(%rbp)
>  129: 03 45 f8              add    -0x8(%rbp),%eax
>  12c: 83 d0 00              adc    $0x0,%eax

Are you using Clang?=C2=A0 There is a long outstanding code generation bug
where an "rm" constraint is converted to "m" internally.

https://bugs.llvm.org/show_bug.cgi?id=3D47530

Even a stopgap of pretending "rm" means "r" would result in far better
code, 99% of the time.

> Apparently add32_with_carry() forces the use of use of a temporary in mem=
ory
>
> While
>                asm("   addl 0*4(%[src]),%[res]\n"
>                    "   adcl $0,%[res]\n"
>                        : [res] "=3Dr" (result)
>                        : [src] "r" (buff), "[res]" (result)
>                         : "memory");

Just as a minor note about the asm constraints here and elsewhere

=C2=A0=C2=A0=C2=A0 : [res] "=3Dr" (result)
=C2=A0=C2=A0=C2=A0 : "res" (result)

ought to be just [res] "+r" (result).=C2=A0 The result variable really is
read and written by the asm fragments.

~Andrew

