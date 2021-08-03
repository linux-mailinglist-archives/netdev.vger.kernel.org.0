Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B183DEF70
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 15:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhHCN4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 09:56:47 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25600 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236045AbhHCN4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 09:56:44 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173DGioQ016340;
        Tue, 3 Aug 2021 13:53:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=mc0rv1449u54t1SBf7CRIqWRLBpqKys823s528t4E1Y=;
 b=NUrJH7AbCQwDs/M2Y1wq4ty6RtXD+1bU4kBxFpRR0uMSuvWbHuCeRbMSLj5sGunB50R4
 ehVDVNK5lR1D+Yb+AJMyvyDrc82AwZKvkxMYRg+0tCAsM7S6mwpyoJbID2YxPXH3bt6d
 K7L1iQtqjuOD+ZSVLBE6g0+JW5D+lvT0+EFPF/xyuS9O6QvKsqKNodqtP7pQ86rzEQv2
 sOWj3JGWyOThisRJgZtBs+uPgNkNhiPte0EwcLegfMckoA/PS7vWQKnYeRJ+ZKC9DGNb
 YLHXX8BgTrSWnkET+3Q0cwj0sI9jDlCvr/NU8AeHqhtDRA+PikrCfjL7sbuv4Zlvy0YZ Ow== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=mc0rv1449u54t1SBf7CRIqWRLBpqKys823s528t4E1Y=;
 b=OzK/ZB653cf0W9Nan1w7lLxrc5WYwWN+DbhOUitE4eHK9BeaVfngJ/HPv1bzuZi+vA+J
 DzwhuK1cIjGy1Rk8zQOce4Snlq/w/pWyxXPbfb5MoOaGV0yuSjZKNruMO2IJf8LD25dQ
 zVLfQ9TPP7crC13N8tr3bkLNS+hGa+x/NYPXoKFGddc6ctahXI7b3P/MRFa2kJhEXktH
 d1l9VC6zuEwV3rwcwfCu6wEC1/CmA4GONljLdjEKgPF0K4H+NNuPZwXfjg3wm9iL3VRj
 4+eii8dKWYGMA8RofY/rj9xnOBZ2k63+itemt0OurZk9oh5Qzata8d5kYOXNOZ+pcbWR gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a6fxhb65d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 13:53:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173DpJmD038355;
        Tue, 3 Aug 2021 13:53:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 3a5g9v4ayq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 13:53:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XB1/QlHIPFvtLXvRffdRBmlKD+wEPXxdLDwTRLoUugVhXQKmbGvQSkGjYvjs34GDtDmCBWc3BVUIe+ejgSGubVaBd1O9Ku3f6j/9pkc+U49ylOP70zf4RYefVkgME/5B9agl5Uh3IUKUM0t+5dO4n1kUp0277Gkb/gY+FEwBNNZKOzZdQPp1VoRg1ZJCe3GqW59LBP9wvyP1BlIJG9rsLQqgTsE4aA5NQRRc+Bj5UrPDwY2fpu9oPwj+mPpOwQZNQ8D3lc7Hxbpt0msIqTDCl+7byHooBYrcyPcsm8JR0eMR9UCKmpzaXfsyl2UTLmSQynDIte6uqNIpkFgb3/LcGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mc0rv1449u54t1SBf7CRIqWRLBpqKys823s528t4E1Y=;
 b=gFlx3qfw4scBrJYT3A9cyyKpyR3WdoirxH5JQ75rMK/Zs7m5+yoiuBnKfty579nGabuUPMZXjmBTYDaWrrBddJOShp7W3h4jVvcHQ/9we727Kv063KVAk5FaYlPlM8PUfV/tSfT8X8AGP6VqvnL2mabkhlpKtlVw0hI+qRwQJKNbi26YOQ1IAp+HS/nQ9uACtkF717hBsrfBJEXsXGmg8aiN8hk/sn6E7+XPoRaBYtvFzJfSqjtPcsWz21VCFvvgy/UYsf45OyJNYhzZsq7cfg+1qi9G5v5jfg+RgyIS0WNBDSof3LPxp0L1QFPIiFaP9OJWDYdpDL2YtoS2mcvpfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mc0rv1449u54t1SBf7CRIqWRLBpqKys823s528t4E1Y=;
 b=uuyJ+W6l/so1KWW0z1pKj8qJ9QtF4qnqyUGyVCFqWPovu2Dktk3sfFWoY1jOaefvP1JA9KTHdGcNBzzPZREBWbOEIsH7K9NG0hZyV5VN8JM02NQB8hJixuc35iDtgQgZei+YYBVfbGfBFRKebgGJ+1kqlehp+l8H/hzAgiJjzkY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BLAPR10MB4882.namprd10.prod.outlook.com (2603:10b6:208:30d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 3 Aug
 2021 13:53:19 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::f10d:29d2:cb38:ed0]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::f10d:29d2:cb38:ed0%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 13:53:19 +0000
Subject: Re: [PATCH v2 5/6] PCI: Adapt all code locations to not use struct
 pci_dev::driver directly
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     kernel@pengutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Russell Currey <ruscur@russell.cc>,
        Oliver O'Halloran <oohall@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Michael Buesch <m@bues.ch>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        xen-devel@lists.xenproject.org, linux-usb@vger.kernel.org
References: <20210803100150.1543597-1-u.kleine-koenig@pengutronix.de>
 <20210803100150.1543597-6-u.kleine-koenig@pengutronix.de>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <d829c037-fab1-c886-7d33-f04f895f3aee@oracle.com>
Date:   Tue, 3 Aug 2021 09:53:06 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210803100150.1543597-6-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SN6PR04CA0098.namprd04.prod.outlook.com
 (2603:10b6:805:f2::39) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.97.38] (160.34.89.38) by SN6PR04CA0098.namprd04.prod.outlook.com (2603:10b6:805:f2::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 13:53:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37d7087d-83c1-4256-b078-08d956860c71
X-MS-TrafficTypeDiagnostic: BLAPR10MB4882:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB488218AAF5D031ADC6FC687C8AF09@BLAPR10MB4882.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:220;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pJbbt+5/9kOx88hw2B+e/dR3hqeLGfOWg0qKPQ1rLn2G8odXH6Og3cq0j23ZuY3529lkNoglnlfdpingHqyErdlmrq4TGMpp4GbH6yYjpeU+V0jiMRCFm9l1SEherH1rnrvn+YI2iqbVVthwC/i1GKX9556Y0Ib1B2g5dAaV1q45vZpknprEzsXIvLg7xnwht3hk90mGbl/bqlf1+Wlj2sE8u6A6DOHArQVnrE/HTOWzYK927VEDDsZ/rKquJV3rh8qThc5juiqx7D+ELR2QoUDFNXPi4XBksWmQWgg4uRX/815ljP2+EW/trsxPa+ZBNEZO1WzLq/sDU3tjjauy2rn3KHwcAaVzXU9bcvF32E/9l9iWzjeZusvn9Kp+zgwic7qnVREyhmaSTZGr1wD/wxSfn2UPq64rnATU69K5Ss8Ys54zYUSCYLny+yNYv1h9xgKdezUfWgH4KNNBlG/Tljz/E+x/YaDMWi2Ge9hogn8pCkyNHnqRc4kR52JrRNPBkeDopYlxkl8gfu6JB/yvK1yST5CKq6n/gd3oYFA4mCOLaMY3odvtvMadrqBW5t8LosdZWn1d4EhN4pOMC9NJqY7WtnF6opRm0FB1l7fS6B3K+p9jrgFJJW2r2Bbiou6IBOYL8aSFThSomzWdJFYL/UfCDvcsKxlUDDG3/UaV1+/k/3P0bL+7VOSfsakA+SKJWU4kIBtZbEV6TYqVAr6iIOuilu+8RpA7xhZoOdYxTxY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(31696002)(4326008)(6486002)(86362001)(26005)(478600001)(53546011)(8676002)(8936002)(5660300002)(36756003)(38100700002)(6666004)(83380400001)(7366002)(44832011)(7416002)(7406005)(316002)(31686004)(66946007)(66556008)(66476007)(16576012)(2906002)(110136005)(186003)(54906003)(2616005)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFpLZVpHOGY1aE93bEF5VzlVQlJDeW9kc3diWUhDNERuNTlpdTNmRWhUdFQ1?=
 =?utf-8?B?MXVOY2lrZUlEMDdzWEVHb1dzaTdtd1lIUTludUVqaGZ6eFREU1JkNlAxRmZL?=
 =?utf-8?B?Qi82T09SV25YeHp5dDVSU2FiMHE5bU9KRVB3QXZhYlJYeWhFcGRjakZXWElX?=
 =?utf-8?B?MldObnBJdjFtUFRkbUhQREFidEl1dmp4bGpmR0QxZFVwbmZMdUgwK0t4ZVpn?=
 =?utf-8?B?ZEdQUzFJWE9oZENOY3BzMi8rSVRxdzF4WE8yVEdMbkpuMEJ1cUphRldvU0x3?=
 =?utf-8?B?eWU0NzN4ODRVMlovQTFxaWQxYnNuZFBGVGRMQ3hnWkFSWXoxcHp4OVZXeGda?=
 =?utf-8?B?VEpUYnJ6emlNN0xPazlKN01FTEZlQ2w4c09CeVpFSkRLbEdHWENtbHl1NDRx?=
 =?utf-8?B?dVNJeUNSdVV6ZlpiNjRnd01uNkxLNzF0VlNGMmJ5SDVlbG9rR0ozdytnczRT?=
 =?utf-8?B?MnFiZllvN1BVQjNvQVZWTHAvMTF6ZGRvYVUrdG51dHh5bmhycjE4eE1DTE1H?=
 =?utf-8?B?RFh1US9waVdpOFcwR2Q5WllNb3g4aXNNVkxKVU9OU1c4cm9Qb0pFT2MwS3l5?=
 =?utf-8?B?TU5mMzAyQTFSUzRyaGdOMHhJZmIrMmtqdFo5VFh4akx3Y1AyREZsMnBwZ1dl?=
 =?utf-8?B?V1JQY0VJanRyc2hyc1k3WUNuYUxuTWw4Um1hdGh5cFZzZjdkNVhaZTMyUThj?=
 =?utf-8?B?L2xVY2pqSEFVbGRvazdFM2JmNzBFNlpNRnpERFk4cW5ydnJwVk1XZ1V3MnBB?=
 =?utf-8?B?NGttdE5NNEVMdzdza1hBRFM1eFNiZHVIN01CSEdITjNNWlZmdVZIQm1XRVdN?=
 =?utf-8?B?MWNxNkRpZ2NYRk94TzRrWHpNckMrZ1paZXNPd3pwL3FRZEpMVGl1MUZISzdH?=
 =?utf-8?B?dkRob1R2Kzl5cnlRcUMyWm5tY29aVS80cFo4Zjgxc0F2UUJUYTFudWZXVUhY?=
 =?utf-8?B?L1RjZE9hbXk4UTFKMXZHUHJHczl3eTNkZlc5NVJOZ0dsU0dNTmJ3dTlxMlZJ?=
 =?utf-8?B?VjJFV0M2Zk8vMkFnRURSeHlLck5RNXhNcWkzR25YczF5ank3MEUwUTF1NGpl?=
 =?utf-8?B?d0lyQUNqQWhjNk03cVNYWE8rbE9uNFNCQkZlMjdOWVpadU1jSVQwT2ozWUhX?=
 =?utf-8?B?Q1YrNGtUTGx1Zkw3NUljRWVyQitWSmhSSUs5TmVJS3B1MEdQMXh2TkxsTllF?=
 =?utf-8?B?TTVnditQQ29KSG8raHppYVFUQXpuWml0VzY4eStvSHk2MlJyYkh4UjI2N0xF?=
 =?utf-8?B?V09SMlVGNGVaVGxmOE41YU1Za2dmazZ3S0grbWlEb3dZZ3pUZWdJMExrWTM0?=
 =?utf-8?B?SGhNd0JsZVp0UDNKVXdzekZ5Y3dKbGR2Ymd4RUQ5bVpZVWlCNXBrdlZERWNG?=
 =?utf-8?B?dm5NR2tyWEhCcE5aOERQTGxKRmR2MzBQNGVKS1VuakpnMGgvT09BT3RqazF1?=
 =?utf-8?B?ZEdtQTQ2em1CNzc4UE43U25DcWFvS0lmZ1BvOVp4ejdReFQ1NHRnQVk5Qkgr?=
 =?utf-8?B?V21FRVB3MEpnd3JXTmJ5Q0JpYVZ1RTVlRnZJTEhHaVNWZmFtSlE1OVN1Nk5H?=
 =?utf-8?B?UWcyaE9meTJwbFFGa3NkbWpXOGpyZitsNS94TXRLUHhVMnc0Wi9ab0tSTnJ3?=
 =?utf-8?B?ZDFBZ0NXVEdsYitGd3ZTekE4TGFBSmJnVkJ3Qlpra2ZGL081emQ5cEgySUJH?=
 =?utf-8?B?SzNXbVp6SUVZSEs0STkzcXVwYU1KcEo1Qk80V0hoeDNYYjk4cXBMM21VbnJs?=
 =?utf-8?Q?u++K/dGtrLnXLIJa3V53YiAFG4Hu978PvfzVbNj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d7087d-83c1-4256-b078-08d956860c71
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 13:53:18.8559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zkce6/FDLIFABseQgPNxfSWxiaCbO+S72NwtAQH2zQBQjgiRdAeeoZ9RhSpcUqhG5J9RN9lHXD3jORKQ+IpJ7ADMDZXmE5+q2SRmYWa8pc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4882
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10064 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030092
X-Proofpoint-GUID: 1zfowUBAnsX5uRsxf3xD4UCQWk3eimm2
X-Proofpoint-ORIG-GUID: 1zfowUBAnsX5uRsxf3xD4UCQWk3eimm2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/3/21 6:01 AM, Uwe Kleine-König wrote:
> This prepares removing the driver member of struct pci_dev which holds the
> same information than struct pci_dev::dev->driver.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  arch/powerpc/include/asm/ppc-pci.h            |  3 +-
>  arch/powerpc/kernel/eeh_driver.c              | 12 ++++---
>  arch/x86/events/intel/uncore.c                |  2 +-
>  arch/x86/kernel/probe_roms.c                  |  2 +-
>  drivers/bcma/host_pci.c                       |  6 ++--
>  drivers/crypto/hisilicon/qm.c                 |  2 +-
>  drivers/crypto/qat/qat_common/adf_aer.c       |  2 +-
>  drivers/message/fusion/mptbase.c              |  4 +--
>  drivers/misc/cxl/guest.c                      | 21 +++++------
>  drivers/misc/cxl/pci.c                        | 25 +++++++------
>  .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  2 +-
>  .../ethernet/marvell/prestera/prestera_pci.c  |  2 +-
>  drivers/net/ethernet/mellanox/mlxsw/pci.c     |  2 +-
>  .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  2 +-
>  drivers/pci/iov.c                             | 23 +++++++-----
>  drivers/pci/pci-driver.c                      | 28 ++++++++-------
>  drivers/pci/pci.c                             | 10 +++---
>  drivers/pci/pcie/err.c                        | 35 ++++++++++---------
>  drivers/pci/xen-pcifront.c                    |  3 +-
>  drivers/ssb/pcihost_wrapper.c                 |  7 ++--
>  drivers/usb/host/xhci-pci.c                   |  3 +-
>  21 files changed, 112 insertions(+), 84 deletions(-)


For Xen bits:

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


