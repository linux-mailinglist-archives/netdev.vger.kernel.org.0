Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D330D6D7954
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbjDEKLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 06:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbjDEKLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 06:11:19 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDBD1701;
        Wed,  5 Apr 2023 03:11:18 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33560W9C016721;
        Wed, 5 Apr 2023 03:10:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=DUNQIPjLOFhNgJV/xi8zaP3UOY49BTf0/+WwgwCwwDg=;
 b=eJWDcbYZa717ukj8g3R4jYsI29jOugkMJ1C1d1pj+pDemEGBTGcyEefvGS29LZFvbRpk
 GHaIGJUGdNrauugJsX51HftHsB+xo/5rNp993WjirasKUH/Dgq8KR8c3UQ0OW+nMd7+v
 1TcqVUUwCPOhUXmqrdsJ/VbZftB9a07jwnFI7T85pNZlr2KzJl5fZjKusVKbuezMzRGq
 7ayMZrxSgubS5QKqJH+21za7MNX6dLmm1IGQWue6qGmGWtUwRS9y1SOn7Se+/yzgWZH8
 C5bPA02VLKcUN8+k181PIV+CpEHBrLbsAU5GIoSsryJZ2lEkliOaQnlwLWbYSihrI5qN zg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3ppkhxndsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 03:10:45 -0700
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 23328400B4;
        Wed,  5 Apr 2023 10:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1680689444; bh=DUNQIPjLOFhNgJV/xi8zaP3UOY49BTf0/+WwgwCwwDg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Tba+FciOVCyD6B+6cljSXlI3NA8DwCaiSYLmnW7eQZOGWOtUGX/cfER3AHwqfABH+
         lTV6yt8tyu1MudLs3v5PZriX3XFBhrLCPU4o/TrFCuKTBsfCTQNKbBPKRXRD8ml/x8
         Ido72e6IWcdWiIddSeB6fyrgsScfwrcsUSPGFy5T9pO9wOWW9f/dmwFpkkFXl5JCXk
         H1rXsXvcM9dCzt++x5H1OamjP6GrF5LPlETjo5EvWIsZzJZqC63TunmcqklxO3DuA+
         gIj7/FpJICks07Popguh3Tunv01RKwuTMnQQ1ufdyJAebOZIDgk+PLVjrmKk8cN1oK
         /cmY4JuMJc+fA==
Received: from o365relayqa-in.synopsys.com (unknown [10.202.1.143])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relayqa-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3D3B5A0087;
        Wed,  5 Apr 2023 10:10:37 +0000 (UTC)
Authentication-Results: o365relayqa-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relayqa-in.synopsys.com; spf=pass smtp.mailfrom=synopsys.com
Authentication-Results: o365relayqa-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.a=rsa-sha256 header.s=selector1 header.b=E34408YC;
        dkim-atps=neutral
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relayqa-in.synopsys.com (Postfix) with ESMTPS id 2EF7E220886;
        Wed,  5 Apr 2023 10:10:37 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvBhWdrQgsQHpQYQlmw7E7lINBR5+eiT6jIkWH8YUxBdkpV4O5PlE6jdd8wPabIiWM+cTzvG0kRbeQaZvCa1uucQpvwxLgNLu1gVkEgdxza2ZYNUxbN9m2XSpj86hwLa+6+26G1sH9TGUb1kJ2pi2Ubyyo+bi/t9Bi5s9F5axST3sS70yQO6kEvrsWtcywGUsgWf6ROADwPxPfrOc8dZMBfL0Z4+0BKiAItfDcTTzfarSinKs149B8+P//FIbQbmEn2lGKU9e+nlb6lxhjw1rfJ9vSFZk7lTGph/mniUQayzQYmZMkneItmL7SL7fSWtS+zsWferH8+fsJ7Z23fgog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUNQIPjLOFhNgJV/xi8zaP3UOY49BTf0/+WwgwCwwDg=;
 b=Dj0XXL3qgyBlxgMnzIaBahXcA7193Jvr5TPqWBAlTY/cEKVuHN5tHHrKUM8Onp4rTOlcDhBUMuinPEx6t8c+4VG/of5KThyyG1vrDZLagIkANcR2qSvjlGoW46nyR+5BOenIlD43vCNVSk4kQdx5SEx8Ib7vFEhd89iDKDAwEvuHPT7PjRvroNQ1ua080+eEUnUfyG8akUsnTa4UU03wmBpENtmsgzc0/fZq85YbUO48rgyQt+glBl6GODv012sDBZFa1kKlzCQ+xW1MeakkPo7QWElasFlt6aMMDcSy3L+LwRQXNBtactnmVv3DjpSfnxgMf5m5OPyukFkHYSmsmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUNQIPjLOFhNgJV/xi8zaP3UOY49BTf0/+WwgwCwwDg=;
 b=E34408YCYwisnnHFqi9nBYl91VZbUQct0yOtnGVN8dIyw638hLl6Z9S7CtBzlKvj/4j9KzzVJM0kOghUb4Zq6MXlb2YUc4pIpjUGu9/+90oRtc8kxsHUwvR55QEClfU8Hy0cW3mcos6lCDbFMTW0MT0h8KRmVBPH9LlJ7DDg+iQ=
Received: from SN6PR12MB2782.namprd12.prod.outlook.com (2603:10b6:805:73::19)
 by SN7PR12MB8820.namprd12.prod.outlook.com (2603:10b6:806:341::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 10:10:35 +0000
Received: from SN6PR12MB2782.namprd12.prod.outlook.com
 ([fe80::16ef:a4:a1eb:6c6]) by SN6PR12MB2782.namprd12.prod.outlook.com
 ([fe80::16ef:a4:a1eb:6c6%4]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 10:10:35 +0000
X-SNPS-Relay: synopsys.com
From:   Shahab Vahedi <Shahab.Vahedi@synopsys.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
CC:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "hock.leong.kweh@intel.com" <hock.leong.kweh@intel.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        Vineet Gupta <vgupta@kernel.org>
Subject: Re: [PATCH net 1/1] net: stmmac: check fwnode for phy device before
 scanning for phy
Thread-Topic: [PATCH net 1/1] net: stmmac: check fwnode for phy device before
 scanning for phy
Thread-Index: AQHZZ6K0q6ehNDvGEUiMYWCtPaujMq8cfZ2AgAAA5gA=
Date:   Wed, 5 Apr 2023 10:10:34 +0000
Message-ID: <10eeb67f-9d9c-a07c-1cce-d5bbcd565ab2@synopsys.com>
References: <20230405093945.3549491-1-michael.wei.hong.sit@intel.com>
 <ac972456-3e0b-899f-1d84-ce6f11b87d27@synopsys.com>
In-Reply-To: <ac972456-3e0b-899f-1d84-ce6f11b87d27@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR12MB2782:EE_|SN7PR12MB8820:EE_
x-ms-office365-filtering-correlation-id: 520a93d0-797b-464d-8f17-08db35bdff2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9SbvVFD0zzjHmdECeg8zFlH1HUDPv7ty1H2hboFruM12YcUOHbt6Ex2iw0WpUMnU5YKEMFtL5W7hZfatakszEQ6nPxNgD4aW16V26p3smctFAd03X0+2K8dut2Thf4Garyf0kiNmjPquavii7P2MNKioir6gSmWTflyCQZh5r/CrqCvv246ZiZMWgVhEoyewTt92WDxPjrEwe3FTY6vs38/11rtFqp9MBHoOJIg7rNtb/ki/DE13IWHDt/qu9MRzxnDBhsu5ZdOyJ8TlB7lPW77vjGB2lvofxSXletoZjcMpDzWEaprCMO145CmhPrn0Sf0OKCdKveCtt+K6gFpR1IOTd3yeQ22G4zrSLFnBod0Ufwch6du7JViBJ/q3NvaY5xuvQEFqTBfdVPxmC4+yfinwEHDxyRva0jZQ4kfoy1b5mWi50fGCMuOnAs5wichqfX/O0tYXoynFPmDNE1wjOXn7COGvTCFBLBA89wh+Kf/TBzuyZhkzokRmE9pnO0pYou+n62bEgMQXl2ram1yHAEZvTEYZWOz6JSmXX2STHSPOr+2Hl4Zkg53PkASxyGB9yPq5tQ6oYHF/ebY8JoJoJggmbIqGXUsmwzYogj5VglGl691IeRYDTZPwwjLbfN2Lru4kOPA0fbCV1xAkWBWr+4ZEuI9PUqcac3gNbiC+lbE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2782.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199021)(478600001)(54906003)(316002)(110136005)(5660300002)(8936002)(38070700005)(36756003)(31696002)(2906002)(4744005)(7416002)(86362001)(4326008)(8676002)(66446008)(66476007)(64756008)(76116006)(66556008)(38100700002)(91956017)(921005)(41300700001)(122000001)(26005)(6512007)(186003)(6506007)(53546011)(55236004)(31686004)(66946007)(2616005)(6486002)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFp6bS9qSFJsK2prL1VSTWs3M3FIRUI0dmFVQVd0bmF3R2VKVERNYTM5MnlF?=
 =?utf-8?B?QVJQMEkzdnJNTDdDTUN3RmQyU3pLQy82U2JDTXhFbGFISkVzTWIvK0VCVjUv?=
 =?utf-8?B?NkZEbzdZYUE1bzNhRG1hZk5DVGxEUWM5VkJjQWdNViszaFZsMWpHMFZtY2Nn?=
 =?utf-8?B?ZWF2UTQ0VEh3bUYvbDBDN0I3N3VlKy84c3RWU21DemdHMVN3Wk1yNkdhZ1Ar?=
 =?utf-8?B?THVjWHRLTXJLNkVDeHdla25aK29xckdFUUtWUmg3eGVQSTZsOXpJNlc0Z2Jy?=
 =?utf-8?B?Y3YvUkZ3Zi9NMDZ1SDNVOFQxdVhhNTllczdQRnM3K1A0Q2hJQnJvZ3JlZnNP?=
 =?utf-8?B?M1JMdFRnc3BlaG5CZEc4cThHMnJJTDl2d1h5WDgrLzRvY2kyRmhoTHVCUlVs?=
 =?utf-8?B?enNxU3Y2YTMrSWZHbHFkZXBQNXVtWTA0bExmQ3RZb1hqaE1nZUkvS2pNNng2?=
 =?utf-8?B?Q09wY0lGWS9VdGduSVI4SkJFM0Vlc0NMRjNHSFVsNjl2ampMZjc5SzlQbEV0?=
 =?utf-8?B?LzhnbStDYU5SZm1JSDhnd0xoK0ZCTFIySnNNTFVmdWUxS3lPbzZKcGRhRHhU?=
 =?utf-8?B?L1ZJclZ3RkN1dy9aaFB2TVhHTW1BNjI2eWIyWWdSQitiYkRDdUo3VTFoU0Vl?=
 =?utf-8?B?bFgvQ3ZuenQ5RHhVeFAvRW51QmhUcDZLcFA1TW5vcElqa09jekdlOTB2dll2?=
 =?utf-8?B?VERVU05jT05aNFMxQ2hPTG9RZCtCUlVtUnk4UExHb2JqWEt5Y0FUMHpJQ3R3?=
 =?utf-8?B?eHBJS0VLcUY3aUwzTVRRSWEyZ3Y3RG1RajM0dWlqUFFhN3k5RVpFRkFoUENR?=
 =?utf-8?B?OXNKOHpKdGFxdzFFNGNqYjM5aU9UaForS0lIZkhMZnNyVkVqZHo2MmluR1ZG?=
 =?utf-8?B?eEhFT0JkSmxEMU9CcG50QjArZGtGMkpRWUoyS0JGckZmTEVUNWNDZEFRVC9N?=
 =?utf-8?B?K1hSczBaTEJjWFFIVFlxb2xqZ0VWYXhaM3daSkhad0lIMU5oMkYvMzA0My9k?=
 =?utf-8?B?OTEwNFFpL1BsYVVHUm1wUGZjTGNzQzF3dDhEc0pnU2NYTERvdEpKTnIrdnRV?=
 =?utf-8?B?dVhxTW9rd2VvcHFTeTVUWExkQmRMUU5jK3V3S1N5MzZxNm9QYnE5a1NnQk1o?=
 =?utf-8?B?WkJoZkt5UldRME5abVNsSG1pVTdvbkVMTEFDZ1IzZVlEa1lZVVhXMnVROHpL?=
 =?utf-8?B?bzdJYkEwaTV3Mm1zN09QVFZTL3dTZStjT09iSk1mWnlBaUo3VlVIRzZTVXQ1?=
 =?utf-8?B?WHdiN1BqOG1zYUxDVEl5VWFtbzZlWnQ1UW5RSks2cFFNNVUxVW1DaVVPaTF2?=
 =?utf-8?B?RldPdm5pUjJwaWN1Q1E0cTFpdzdTTVlkdVNlL3BkR3JnWXZtUkE5YjRFUXNR?=
 =?utf-8?B?czUxNStjNVBEUU5ncDBSYWxVbVQ5R2xvOW14VFZoQWorU0k0eWpxcTlGK1Jh?=
 =?utf-8?B?Mi9MWFlYNitxaGFhV1VIVzdDT2tqTTRzL0VWSFhmeUdMYURjcjdpMVVCYmxY?=
 =?utf-8?B?ZVQyeW4wNDBTbzZ2emEraUQzM2NIZWdpR0ZzNDVmd21NcFRIS25TTnpUNVBB?=
 =?utf-8?B?b2xRTWJUV2U3cEdRQjdwMHc0VmtXM2xDS3REQVJ3UDN1TlN4OHRvOW5hWXNo?=
 =?utf-8?B?V2RScXl0Wk9QUXQwU3JDOUx4TWwzQkFKeTAyNUpPOXdLK3FOOGh2ZjFxUnI4?=
 =?utf-8?B?WXJIVWUxQzdERGNEb3VySUtWdkxQZFFMeDNLRUV5MHFzNHBwdDNyeE92WTZt?=
 =?utf-8?B?V3Z3VzhmdTJkVk16QnM2N1lNd0RRdlpwbXh0aG8xV0Mzd2JZS1o5cEkzazZw?=
 =?utf-8?B?NEQxZk04dXFMd3YwVlBXT09EVWVHZW5Ham41WWVxODlMcU11Z0NpYWtNYU1m?=
 =?utf-8?B?TkVjQzIyTldmYTZpTkUvZE1mQklSNjIxZGVEc3RzQ0p2T3Z4R3U4bm9wQmM0?=
 =?utf-8?B?RW5kNVpkQjVkdjhOYjFyby9iQS93dmw2Y2FzclJURXBpV2t5QXBhSnRWZVB2?=
 =?utf-8?B?eWRabVhvQW91R1BwUUVGWmhaUjQwakY3amZoZHRpT0I5cmVaTGZoREVSUG5H?=
 =?utf-8?B?ZnJIOHFqaTFYNDNvbHNjdDBTb0VVSllQSDNQc1pxbStHM3hoYU9sMkQ2NS9w?=
 =?utf-8?Q?yjy0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3849ABD34D599D4F973B3E31DA50FED2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bmdlT1NXekZuZHVKRCtrZHRlZkVFUDE4V2huUWowQzBaTVM4TVBPc1NzdDE0?=
 =?utf-8?B?WmhtMGxNRUFNcDZQeHVkbnZEbXUzTk5CL3BXaWZQejZDemI3aWt3YTZhS294?=
 =?utf-8?B?QkJ6a1J4U3ZEWjVubVZNTkVrQzVzNFMzWnQ0YWxaY1pFZHJpQzAvRE01V3E4?=
 =?utf-8?B?V2hhYjQ2d0FzWWxXUWhhbDdGR3dlU29hc1hUOWkwaHNySklqRWhrRXNKR0do?=
 =?utf-8?B?eWpPZzVJUXNqdis2ZnJMekp5WHNlbUNDTWtiVzdINk5RRmo2TkJyZzZTUXp2?=
 =?utf-8?B?N0E5OGFhSzM2b2dZNnVrb2ZZeDZYRmZWVzRtNHJiVklMNXJvUjF3Rmc5NmtK?=
 =?utf-8?B?UVhUOXN5Rlkzb2NFRHdYOHVQMHZuNkUybEhBckFvSHpEZHFSSDJNQkNTSEVB?=
 =?utf-8?B?YUUrVDVSYUhZUjZzS21RZnUxaGttaU1CMVRmZll1ajN4aFovUDI0STFMeDRV?=
 =?utf-8?B?aVBoZUFPVUNRZGlVem5JZlNlWFVNUytnSUZNdnlHWmdrVm9RME5QeXBiSS9U?=
 =?utf-8?B?dFdzTVlGSnBjRmRqN05LUHF3bUc1dWJ4UkpCaTBFd3BTY0dwK0orU2Q1SFdP?=
 =?utf-8?B?L0xiVFhtMXJmQVo5RzZTbkVIM2N1aDN2MmxiNTl4TXBWQlRyTFp0ejNyVEZ2?=
 =?utf-8?B?TkJEQXM2VDZhV2lPUlJXbllnckJoQ0pwaXZ3d3lobVpZdXNBUjlmQUhlUzFG?=
 =?utf-8?B?UXpxK3ZXSFhJTXZkL1AwL3Z5ZkVVaEVsY1dBL1RwcTdrUnFSWU9POGl6a3Rm?=
 =?utf-8?B?dG95OG56bUNZaHlXc1RyZFgvS21LNWt2TFphbCtOM1dXNVdwYnk5cmc2OGlk?=
 =?utf-8?B?QjZRNGd6TUdDeDlwb2hIMFp5bjRmUzVCWXVDWEN6M1FrZ0ZmN2tOdDB4bmVQ?=
 =?utf-8?B?RFAzOGdWQlZYWW1McU9UVnJFcG16RnVXVFlZOVplTTBqcjlvVUFWMlRycU1Q?=
 =?utf-8?B?aXc0WHNUMkxqTzB5ZXlxQXpHSDJSdDNWcm1oMjROVjJJU2tlYXN3UWRCTkhG?=
 =?utf-8?B?ZDRUa2oxZDhubWFsVC8yVjRNWlVBdXNsMjNUQiszK1JqRHpSZmdHNlhzcGpp?=
 =?utf-8?B?RVBIbUt3M0xZL1ZJWlFZRUdkTTQ1dGpOVWJ0OGoweWJ4YUUwZjh5VGpXcG8y?=
 =?utf-8?B?SWdhYkFpRzZiRUlrdFRFckYxVCtuUjczMzJLb0dwaGxRYVpFUnk5anNuUE1T?=
 =?utf-8?B?eWg3L2dSSVNrOWdxKytDQWdKZGhCbEV1cUpTc0QxKzBVd1g1bHlWanI5dFVk?=
 =?utf-8?B?c0M3WmJ4ZnNSY0ZaL05iVVNrV3FhenlOb3VCVGJJanpjT1BMZHhROHphMmpY?=
 =?utf-8?B?aDB1Znd6OUcyaEYxckFWeU8xVXlSaUtjV08wZ0lpS2xoOWhQRTlHWjlOdXVs?=
 =?utf-8?B?Y2RURkRNL053ZUg2UzhhMUxKNk52RWJGbldWa0FHK0hFMTh1U2RYTDRidGt2?=
 =?utf-8?B?U0ZsL216SHArMzh6NDBzSWJyMytPd0RIdDk1SEcrY1JiMUhqbnNCd2VjeElh?=
 =?utf-8?B?aFRLcE1ZV3FrVGI1eEV2RVJRYXJOTkR5SlRQaVEwK1BGOGdQZ2VFN2NjL0da?=
 =?utf-8?B?aEYzaG5BWEhSR2dmSXMvdENzOHJidW9WMUkxcVRITk1DSlloTU5wdnhhZTY2?=
 =?utf-8?B?K0FZcUF5cmo4a1RnYW8vL1FTZzErQzdQUENIUG05SVZOVGxTYmpFWUVZRmVi?=
 =?utf-8?B?bElGYUtCd2huZWFUV1FDZGQ1bzBiTE5CcUtQelBKcnBTQXFIOE1lRm5hbjVD?=
 =?utf-8?Q?EVyTuWxxlYz7kZEx1o=3D?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2782.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 520a93d0-797b-464d-8f17-08db35bdff2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 10:10:34.8953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a+U0h7xkHljxbpC6v+V9ebU5IoIdKM2KMrWM+7KvT4bW8a0U7DtasiOFPInEMSjZeJBbBcrYuR/UvKjpYgXqsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8820
X-Proofpoint-GUID: U0e3c5ixfyLlUw84ZUWXgxuNhhkdjgyL
X-Proofpoint-ORIG-GUID: U0e3c5ixfyLlUw84ZUWXgxuNhhkdjgyL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_06,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 phishscore=0 adultscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 spamscore=0 mlxlogscore=512 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304050091
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q2MgVmluZWV0IEd1cHRhDQoNCk9uIDQvNS8yMyAxMjowNywgU2hhaGFiIFZhaGVkaSB3cm90ZToN
Cj4gT24gNC81LzIzIDExOjM5LCBNaWNoYWVsIFNpdCBXZWkgSG9uZyB3cm90ZToNCj4+IFNvbWUg
RFQgZGV2aWNlcyBhbHJlYWR5IGhhdmUgcGh5IGRldmljZSBjb25maWd1cmVkIGluIHRoZSBEVC9B
Q1BJLg0KPj4gQ3VycmVudCBpbXBsZW1lbnRhdGlvbiBzY2FucyBmb3IgYSBwaHkgdW5jb25kaXRp
b25hbGx5IGV2ZW4gdGhvdWdoDQo+PiB0aGVyZSBpcyBhIHBoeSBsaXN0ZWQgaW4gdGhlIERUL0FD
UEkgYW5kIGFscmVhZHkgYXR0YWNoZWQuDQo+Pg0KPj4gV2Ugc2hvdWxkIGNoZWNrIHRoZSBmd25v
ZGUgaWYgdGhlcmUgaXMgYW55IHBoeSBkZXZpY2UgbGlzdGVkIGluDQo+PiBmd25vZGUgYW5kIGRl
Y2lkZSB3aGV0aGVyIHRvIHNjYW4gZm9yIGEgcGh5IHRvIGF0dGFjaCB0by55DQo+Pg0KPj4gUmVw
b3J0ZWQtYnk6IE1hcnRpbiBCbHVtZW5zdGluZ2wgPG1hcnRpbi5ibHVtZW5zdGluZ2xAZ29vZ2xl
bWFpbC5jb20+DQo+PiBGaXhlczogZmUyY2ZiYzk2ODAzICgibmV0OiBzdG1tYWM6IGNoZWNrIGlm
IE1BQyBuZWVkcyB0byBhdHRhY2ggdG8gYSBQSFkiKQ0KPj4gU2lnbmVkLW9mZi1ieTogTWljaGFl
bCBTaXQgV2VpIEhvbmcgPG1pY2hhZWwud2VpLmhvbmcuc2l0QGludGVsLmNvbT4NCj4+IC0tLQ0K
PiANCj4gV29ya3MgZmluZSBvbiBBUkMgSFNESyBib2FyZC4NCj4gVGVzdGVkLWJ5OiBTaGFoYWIg
VmFoZWRpIDxzaGFoYWJAc3lub3BzeXMuY29tPg0KPiANCg0KLS0gDQpTaGFoYWINCg0K
