Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE366D77BA
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbjDEJHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjDEJHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:07:23 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F0110F9;
        Wed,  5 Apr 2023 02:07:22 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3357drGX000366;
        Wed, 5 Apr 2023 02:06:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=ReqYqEFOjfuTqt/VjZhyGVsgGgmcNi1jIl8ioq7f+3A=;
 b=De7DJhErRYBb+RY1PIY6aOQ3qxaJsbDdA7IOGWHNaYuREqERbj4uAGH5Hs6m7MHv0CFx
 16sv6WbY/vvPCLs3xp2XLExgZ5xFdrkacpm2+6zz9HrDWgaqrBtO2tQWNFaEqnx5JCpq
 nVoaN1iULqWs8HbMMhz0dvUub4FrDelwAynxYMlJ1ceWf8oYHT4t/qmPgja0couGUPMn
 oTRaQxo8oMPlORsCVRq81RHQ/weXzYTBS3bAZ3M0XfKWI81yGUbtWgZLjqMpv0Agu252
 zZDHsB9v9bVAUo0+BLFSjIUaJZa3Y0wZIE7bQLmIJ0zQzoWkNzWDQgJ3JMqwPTL2dRKq og== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3ppkv92v0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 02:06:36 -0700
Received: from mailhost.synopsys.com (badc-mailhost4.synopsys.com [10.192.0.82])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CA153C0445;
        Wed,  5 Apr 2023 09:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1680685595; bh=ReqYqEFOjfuTqt/VjZhyGVsgGgmcNi1jIl8ioq7f+3A=;
        h=From:To:CC:Subject:Date:In-Reply-To:From;
        b=jG1TXPC8TP+fW0T13DNmUyffXvVZRRt6/wp6jJUywdu2Ct7URvkgIWhWiAV9yVphb
         VYd8dfGtkywe14Rn0Y40jTtFOz9eG6quMsNZ/SZq9syysZ/sKM5OXPnjxlK6PHFeXW
         x0NRZjqbIiNtj/UB98i7JlzQrT0YA9/XHUGDuVht5esq4Mx7/5ytadlF8ChJcWONRb
         qN5t30nb0JTT1RckCW9BgOc8PYiU8QPvWr6/pCjeYfAEQk5gP+whDksoQm+39SHq6o
         5Ng1BY7Skqt5vXQS3nET+YqZdMDVmOZcypl46vcoPK499BKWQhWAMxEDsvoj2lmEl/
         HBS/s5KYdoflA==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id DC934A00A6;
        Wed,  5 Apr 2023 09:06:29 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id A9FC140066;
        Wed,  5 Apr 2023 09:06:26 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=shahab@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="LxF8YtNF";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ck/kw2/ayz/ETwisZTBimSSmz6+I6JXFewUSCQvdJrPMmEhn9X5wKReT6kemwf3AYDbehsYK0pcI2M5/NltoY0cUXkAg/iaalIHi/jN1AZg1Rwnd38biufEckkTKBZFkIFwgg/VL34bbrdz+BAo3LEgz3jfZYKqep3Fz/UJjV9akULOv1pbuvtGZHaRI0CvMV6HI97PoAWl4DlbjedFrstN/mnmPrEpFlx5d0gy0aEtNhqo4lUz12lJXZVg7WkrgVRqkEdnRLiJ+Mp4v68ridMPlv9ppRpoLSba8gk5bLExON/riJieU1kInTDxvDTayZmINYtZ8I369e6EnxHqJZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ReqYqEFOjfuTqt/VjZhyGVsgGgmcNi1jIl8ioq7f+3A=;
 b=Q4xi8GhwE0x6t5sEzpmBB0KeS0OKksu8RDEIvJjfuOPamOeEvcCrrw4Y59MaIct5cPoogNJ+uEl+XLtxXSw6qI1mmdZ/vXo5OtZ1onb3bDpPNyCeklHqXocGwrOE49xmI9LHePcG2vX3gaIFPpk8dTqEzYz/LX/nMX6c+B+lMTrYg+JpIHKwjzKSdEGukabCmD1YyX0orkFu225f2LKs2U4BqsWOiVHlIm0w+GgFXORhPvNniLb7T/yTn6uCFgw8g4Vg+JwcfC1SDyl5sfIrSL1shCqn8DOJA6Kq+R99fEdkjYiXwZTP05ajoXIhrNPT6FyioTZZXrFpk/S0J5wN2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReqYqEFOjfuTqt/VjZhyGVsgGgmcNi1jIl8ioq7f+3A=;
 b=LxF8YtNFA5NVh16AouQEuWUzblrhuzddZ4w6QKt9sL15nzWKkXL2ggkSIBVe8hI7ydjaHHA5EprJjdc04g3IKa/JLUQysYVBGyeRsyCFm2AzN9UuBi90lV5DJ2XZgvUt6iBEHXR5KRP53ALxgDNh3P3t6W2Bwzw9WA1ekRn+rAI=
Received: from SN6PR12MB2782.namprd12.prod.outlook.com (2603:10b6:805:73::19)
 by MN0PR12MB5786.namprd12.prod.outlook.com (2603:10b6:208:375::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 09:06:24 +0000
Received: from SN6PR12MB2782.namprd12.prod.outlook.com
 ([fe80::16ef:a4:a1eb:6c6]) by SN6PR12MB2782.namprd12.prod.outlook.com
 ([fe80::16ef:a4:a1eb:6c6%4]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 09:06:24 +0000
X-SNPS-Relay: synopsys.com
From:   Shahab Vahedi <Shahab.Vahedi@synopsys.com>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
CC:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Vineet Gupta <vgupta@kernel.org>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "hong.aun.looi@intel.com" <hong.aun.looi@intel.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "peter.jun.ann.lai@intel.com" <peter.jun.ann.lai@intel.com>,
        "weifeng.voon@intel.com" <weifeng.voon@intel.com>
Subject: Re: [PATCH net v5 2/3] net: stmmac: check if MAC needs to attach to a
 PHY
Thread-Topic: [PATCH net v5 2/3] net: stmmac: check if MAC needs to attach to
 a PHY
Thread-Index: AQHZZ53t562vZwfErk6r9bP/RDaizQ==
Date:   Wed, 5 Apr 2023 09:06:23 +0000
Message-ID: <f32d74cf-22e6-7c03-c9c9-a51eb5d10db6@synopsys.com>
In-Reply-To: <20230403212434.296975-1-martin.blumenstingl@googlemail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR12MB2782:EE_|MN0PR12MB5786:EE_
x-ms-office365-filtering-correlation-id: 4b0816d3-ec3b-4226-70f4-08db35b5079c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: llK1j00tgkOeIiBvHzn6i20YfuNqD4GCmKawDFtQ+PhPUrii9BNEjUuSdVLN1+M0pkRxCikz19T7apjF2eZn+PJ5JjWhgeMtJ95Zoxrf9ZJ3fExiicI3VlJjXD8Y0uTRuYdcSuDGw3684QzNAuyPzPTdqF+DncaoZzHbfBuqImioj7K3oTDF29l/E5IaBNDhV+l0Rpc5eIVcqwQvdQqk/LQBADmiP9IwP1FTomgEczONKmaSCaLh+/tTtgaM4GBjTAoUf/m7EEJvdSF0SaC6Gzcf3Q8aavPw0nTHU3AlZt98LIfzz0YzL1gcv5aMiJxUpOVzm287zZHLbYjsoGJR+8KsG2v2o1DXucANGTgwBJzeAF7RNesaZj1ump7f842pHRCVGNT2rdfxeQDUsNYc9FennXdOCNQoYFbhVhP64oOHGfLl8EhmmQDfuE/qhbulZ06pJFUCq8XNv/9i6I+NPBkQv85WAgoDD4ynkgWnOI7rmOzWzYUKxoi8enImLwqxdfS5FdGzvu/+klaqCo/ugBnW7wD8YGVlGCpCBCeyvjs74Iz28lrl70oQI2zub/udw3TjT21DOy0Z6NO9WTrH3qhzAHcQ/0rkAXKZOzNNa1+yVRZhjYiqCNx3S8q2S5jLzGwRB2P2Tuuyjz5FSy0Chg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2782.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199021)(6486002)(71200400001)(83380400001)(36756003)(2616005)(31696002)(86362001)(38100700002)(38070700005)(55236004)(6512007)(6506007)(26005)(122000001)(186003)(54906003)(2906002)(316002)(5660300002)(7416002)(31686004)(91956017)(8936002)(41300700001)(66946007)(64756008)(66446008)(6916009)(4326008)(8676002)(66476007)(66556008)(76116006)(478600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0NZOWlheXAzZ0JPTmRURklKSFNpZmlNby9wb0IxV3NMaGpJbWd4WHFDc1Rq?=
 =?utf-8?B?VHFoL0FBT2I3K1FyUUJjcUs3UE4yTkZkYzQ2Q1RBa3psR2lOWW0zVXA2dHR6?=
 =?utf-8?B?bU94MmlZNnVHSndqL1NtT0owcmNFVzA0STgyUWxicWZORis4eWZqWnZYVmoz?=
 =?utf-8?B?OEJ2WlU5YkxVRG9JR0lMc1V5QVd5M2d6NWxXY3l4MUNtK1FHVFZ1aHpnNHUy?=
 =?utf-8?B?UThBd2MxZ2hzZktENFNwL080S3ZwN2NPM2hETTc0a0hNenJUYVpRZkxZb2Va?=
 =?utf-8?B?Ulk3Z0E5cU5uVDh1TThzdHJ6SkJKRFFWKzl2a2xDdTZoS2cxaWZvUmU4LzFE?=
 =?utf-8?B?ZysrVUNNY1dtN3p0c0paNVpGQ1Z2RDJEUU8veDlsN01TZm1hMDZzbWlIMnFD?=
 =?utf-8?B?b1BqQ2lkclhjcis5eGQxbFlLams2SkxzZC8rdWhDVkszSTRoQ01uZTVYSWd2?=
 =?utf-8?B?SENLdEVaMUtZbm9lWjA1b1p5eWtOa0dQVEJlRVcvdmpmRzFNVk8xcERSUS9y?=
 =?utf-8?B?YU42N1dhcWZKb3BMQmIvZzJXakFWV1lUd3BCMW13dlBpUEwwbUZoNFo3RWZW?=
 =?utf-8?B?b0NDQVR1Q0ZzVEJ4Q2pTWVVONkdaZDI1bGZ6dW8ySlZ0S0Y1Rjl5dXpHZHIx?=
 =?utf-8?B?anY3c2pIcWNudU1lVFFRdGowY2l5Mmdob2RvaUVBbS9ZbEYvZlpocHB5akwy?=
 =?utf-8?B?MkF4QmNtTjFLK0w4RWdXRjBrT0VFZGhoQWpMd3NzWVVuSnZlRjZzWHJhRnlL?=
 =?utf-8?B?TTZ1aEJXQnZxa2p4eWxReUU0T25DSk9DSEdyQ2Z3anlDRWtQUjlPdXZvTWp4?=
 =?utf-8?B?c1dxNnRxSDl0azZUQjcxOFdnMmE4NTQ0c09FL0hxN0J0Mm9kNXEybVc1ZFBC?=
 =?utf-8?B?OTlLS3NYYzFKeFBYQlVlTXVZaFdWU3ZZSDU5MzRzZzRaaFZyRGRqRXExamZS?=
 =?utf-8?B?aFpDOXZ3QkIrVEhhb3N3elR0cWRwMno1UUhlM1lDbitEQ0E5bEVZM0tWMXYy?=
 =?utf-8?B?Rlh2MUZIdnRiMlNOQWk0emtOM0NNL3RBbFRkZXBIWnZVRmM0T0xsclYraGF6?=
 =?utf-8?B?WitCOU54QTJPb2d2ZGVTdmtxbzQ2NXN5bHpiUnAyWUhPRG5pTnhpQlBzbkdx?=
 =?utf-8?B?anR4ZzZ1Q2hGbDkzc0tJaEsxeW1INjJYVGdrVGVLV1NZUU5ZYk5XSXl4SUlO?=
 =?utf-8?B?NHVCNTNmbWJXQXRxeWE2VEtNdEFyWjlERGhQM082ODRBTDk3SjR3MVBaY1Aw?=
 =?utf-8?B?eUtMMU5KNVBsTlJ5N1FsUXlsQlJkZFlhb3dScE1ZYU9naVN2dk1FSlVTSjhj?=
 =?utf-8?B?SThTbTBqMEg1eDVWMTlBSWNUMUNRL1BvSlVOampadU83aEUybXdnWDhheFQ5?=
 =?utf-8?B?TFBOMHovdk1YZ3pVdmZEOWhrMi80WWpPOFdnbFZwT0NjNTgxSERvS0NTUWNx?=
 =?utf-8?B?a2pUR3U0bG1GR082OVl5SlpiM2xPUk5wekhwMm5yUkZrQWFDelU1NHFrejUz?=
 =?utf-8?B?ZXhkcm5yQXlyaU00VWNLRUFtbHNFMnlJMUtBTVZqWHlBZVlSUzdZSGVqZW8w?=
 =?utf-8?B?NlZCQTkrRzF2b2dVOEpkWnpnc1ZNNmE2Y0FPSGNHbmErdHIxSi9yc0tNUDAv?=
 =?utf-8?B?dWZvb1RTRDlwdWE5RkJ6RDNNdzBNNkl4YnNndEMycmp2TmI3a3ZlV1l5aWsw?=
 =?utf-8?B?L1ZjSG10WUF4ZzNTSHBtZmYvNDBDK1RacVQvS0NwLzNCajJ6eS9OYlY3alZS?=
 =?utf-8?B?OFBvSDdyckpXOXVpWnh3OTU3QWphVU9QRmxZU0Y1UDNuU2dKUU9DQmpQWDlr?=
 =?utf-8?B?WUJ5TkprbmttUFZpWXBNSDZQbVk1MnNGdmo3NzhDeTVEV1gyK0pnMWxRY2ZY?=
 =?utf-8?B?QnVhYXQ2R0Vsa3BlM0gzbXExOVdjdkV3THphTDkxV1lYclY1TUhFck9kVi9y?=
 =?utf-8?B?SlU0TWNFMHRWNExJbGxXd3JXMGZyaTA2SHZWbUF3Q0V1UFFBTXpsamVUMGVN?=
 =?utf-8?B?TUlwdTVGeEdaNUNyNnVMQnE3b05hOVdEbFhHWnNVaGZ0QlZ0aDV2K1BuTzNk?=
 =?utf-8?B?aWR4QXN4L3gwdmwycXVnR2gzbnVnMXFiMVlrb1hsSW5HNXpBR3FjSVJlRk81?=
 =?utf-8?Q?KvXM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <754087DFBF4CA54E8A10DECCD3912A59@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TEJYRnFLenF6L3V3TTNxQlptcVNibXZsN1VjdC9XTjZENE9YdEk1NktuSTl3?=
 =?utf-8?B?c2ZlN0tEZ2tHbXhRYXlzUHlBelU2NmlucVdtNWlJck9QSk5iZURlUHhZUlpF?=
 =?utf-8?B?UkRvc2hTQk9LUE5mZmJhc2pGazBDRi9KQVBjMDNpNld0VnMwMEdDMDgrRlpT?=
 =?utf-8?B?SjM4VHpKWDZDTGNDUUc2TVdvcytGNjAzeVpXZDVVMHZ6ZW56dHZsKzJ0eG81?=
 =?utf-8?B?M1E5RnVYdDhRTWJkZ1hDZXpJeFhmYzFzWUt5RnZVQU1hZ0RYdlRsQ2ZYbzdR?=
 =?utf-8?B?Sk5kaHQwelNuSTFEMGxqMk1uRVR4N0U0aDZ6aXBNL2daVmVUQmVwbjFUU1RH?=
 =?utf-8?B?Q3U4OEJZeTRnYmlENWhjRUlXVXhRQjV1ajNTa0RSRm40YjFZV1Q0N1RNa3g1?=
 =?utf-8?B?cUtXeUN3a1Vyb05PbkhrYXd5QlhpZWVHY0JaVWlkS1luV0lacXRmZEIxalVH?=
 =?utf-8?B?cWF2NW9PNm01Z2MvcFB5VVEyY0Q0YndJbnYzS2tyL1o3eFdGMUdOY3FZVGlu?=
 =?utf-8?B?NTdEaUJJMEo0ek8rZ1oyUnJvcVVnUUUxY0R4dTNnNk1ObXc3ODkvaXMvRzY5?=
 =?utf-8?B?RVMzYUlJQ0xwUmlLbC9LN2NZRmsrWmZIRHhlR2ZQeGVpaEl1SFBwcFNZM1Zl?=
 =?utf-8?B?RkxqN2ZZLzUzMTY5RGRrRG4yNDgwQ1B3QWtNaGxiaWpoYlVxa2FFblpqTEM1?=
 =?utf-8?B?Wjk3ZzJ4ZjZLYWExenpuS2phQmtVc1pPcTUyc2NIajJxMURCOUxpdFVaWlRT?=
 =?utf-8?B?YnNwWDQxUHV0MkdKMWkwMFFUd3JMYkdIWjExUXBodFIxUFhNZGswazhjUWtX?=
 =?utf-8?B?UWlNbEd1ZkE1dkVlZXZtSDliYTNvdEZzWXF0Ty9zN21tcFlrallFZllmbEd0?=
 =?utf-8?B?T21IV3U4bjYrNHVTVDVQcFR6MTJkelAzdHg0aTlPWjl0L2ZuRFhwcDQ2cmxV?=
 =?utf-8?B?L3hsKzhqRGYzOGhTblA3bTdUQnFJKy92V3prRXVNUHZCamppcGh0L2QyUysw?=
 =?utf-8?B?Z2xHSzlNTGEvSzRkNmlSTkhpWmozcGFSeFcrYWprSFg5MUxVZHVxWVFsMThZ?=
 =?utf-8?B?WTh0Q2U2NEE0bXUrcGFTeGVVOFV3czVPQ1dBWWpLem4wOE9LTTd3b1VSQmxM?=
 =?utf-8?B?VW1yeENJbUZKa2tKa0FneXp4TnlrYnZJbVVaUzgvM2hOZTNEcjNOSlZ3RXEv?=
 =?utf-8?B?UXNtNS9ZQ20zQmdJMnhmQjhPbzBHMTNMVlJJUU5QRHFrenl2SFF3QkVjYU9v?=
 =?utf-8?B?cHZMR3k1ZlRnR1RWdjJJUmlQZVpvT2dudGRvb093SzhvazhnN3ZpTGJQaGxX?=
 =?utf-8?B?amRmaGtDaldtNkRZdVVVc25hcXU5T0p3VjNnNloyMTNhMTNtdXZWVS9ZUC85?=
 =?utf-8?B?dzZZdXhNVUZFVi8vRE5WNit4K2d1UzZkTHhQdGo5b3JQM0Nzcm9EcUVSZXhr?=
 =?utf-8?B?VGhvS2Rwb1U3YnNiWDZCZy8rVkgzRUQxZzd3dzF2MnhtOVRaWXRMLzhSZ0hW?=
 =?utf-8?B?ajltcDNsZy94eXNNeWlVb0ZzaG9DUXFLRFZPN3dhTGllR3orQmpTeXU5bW9v?=
 =?utf-8?B?MUdpYWZFd1d4R1BsSXBWeFNuZTlUSTQ0NnNMSWx0bnR4aXlrZElZQkVQckg2?=
 =?utf-8?B?bTNXYjBHQURCMW56VEdHUER5YTVKZUo1ZVZ5Y3FUdXBuMGRZT2lVR2NqUW03?=
 =?utf-8?Q?VVIEWC9z6p6Y5EMeBWiW?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2782.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b0816d3-ec3b-4226-70f4-08db35b5079c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 09:06:23.5920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rmEdkPX/nz5fjyAlOW/9v1n1WMXJs04D96sKJ0rnrINxksad74HojiuBo8uClrP4IYDmQp3VLdoLPGRFqjfdZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5786
X-Proofpoint-ORIG-GUID: QDKm9g-AMFC0pbh5Ttj1R396yGu_x-Il
X-Proofpoint-GUID: QDKm9g-AMFC0pbh5Ttj1R396yGu_x-Il
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_05,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 suspectscore=0 mlxscore=0 adultscore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=232
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304050084
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rml4aW5nIHRoZSBDQyBoZWFkZXIuIEFwb2xvZ2llcyBmb3IgdGhlIGluY29udmVuaWVuY2UuDQoN
Ci0tLS0tLQ0KDQpTYW1lIGhhcHBlbnMgb24gQVJDIEhTREsgWzFdOg0KDQojIGRtZXNnIHwgZ3Jl
cCBzdG1tYWNldGgNCiAgc3RtbWFjZXRoIGYwMDA4MDAwLmV0aGVybmV0OiB1c2UgY29oZXJlbnQg
RE1BIG9wcw0KICBzdG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQ6IElSUSBldGhfd2FrZV9pcnEg
bm90IGZvdW5kDQogIHN0bW1hY2V0aCBmMDAwODAwMC5ldGhlcm5ldDogSVJRIGV0aF9scGkgbm90
IGZvdW5kDQogIHN0bW1hY2V0aCBmMDAwODAwMC5ldGhlcm5ldDogUFRQIHVzZXMgbWFpbiBjbG9j
aw0KICBzdG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQ6IFVzZXIgSUQ6IDB4MTAsIFN5bm9wc3lz
IElEOiAweDM3DQogIHN0bW1hY2V0aCBmMDAwODAwMC5ldGhlcm5ldDogICAgRFdNQUMxMDAwDQog
IHN0bW1hY2V0aCBmMDAwODAwMC5ldGhlcm5ldDogRE1BIEhXIGNhcGFiaWxpdHkgcmVnaXN0ZXIg
c3VwcG9ydGVkDQogIHN0bW1hY2V0aCBmMDAwODAwMC5ldGhlcm5ldDogUlggQ2hlY2tzdW0gT2Zm
bG9hZCBFbmdpbmUgc3VwcG9ydGVkDQogIHN0bW1hY2V0aCBmMDAwODAwMC5ldGhlcm5ldDogQ09F
IFR5cGUgMg0KICBzdG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQ6IFRYIENoZWNrc3VtIGluc2Vy
dGlvbiBzdXBwb3J0ZWQNCiAgc3RtbWFjZXRoIGYwMDA4MDAwLmV0aGVybmV0OiBOb3JtYWwgZGVz
Y3JpcHRvcnMNCiAgc3RtbWFjZXRoIGYwMDA4MDAwLmV0aGVybmV0OiBSaW5nIG1vZGUgZW5hYmxl
ZA0KICBzdG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQ6IEVuYWJsZSBSWCBNaXRpZ2F0aW9uIHZp
YSBIVyBXYXRjaGRvZyBUaW1lcg0KICBzdG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQ6IGRldmlj
ZSBNQUMgYWRkcmVzcyA3ZToxNDpkZjo1ZjpiODo3OA0KICBzdG1tYWNldGggZjAwMDgwMDAuZXRo
ZXJuZXQgZXRoMDogUmVnaXN0ZXIgTUVNX1RZUEVfUEFHRV9QT09MIFJ4US0wDQogIHN0bW1hY2V0
aCBmMDAwODAwMC5ldGhlcm5ldCBldGgwOiBQSFkgW3N0bW1hYy0wOjAwXSBkcml2ZXIgW01pY3Jl
bCBLU1o5MDMxIEdpZ2FiaXQgUEhZXSAoaXJxPVBPTEwpDQogIHN0bW1hY2V0aCBmMDAwODAwMC5l
dGhlcm5ldCBldGgwOiBubyBwaHkgZm91bmQNCiAgc3RtbWFjZXRoIGYwMDA4MDAwLmV0aGVybmV0
IGV0aDA6IF9fc3RtbWFjX29wZW46IENhbm5vdCBhdHRhY2ggdG8gUEhZIChlcnJvcjogLTE5KQ0K
DQpBZnRlciByZXZlcnRpbmcgdGhpcyBwYXRjaDoNCg0KIyBkbWVzZyB8IGdyZXAgc3RtbWFjZXRo
DQogIHN0bW1hY2V0aCBmMDAwODAwMC5ldGhlcm5ldDogdXNlIGNvaGVyZW50IERNQSBvcHMNCiAg
c3RtbWFjZXRoIGYwMDA4MDAwLmV0aGVybmV0OiBJUlEgZXRoX3dha2VfaXJxIG5vdCBmb3VuZA0K
ICBzdG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQ6IElSUSBldGhfbHBpIG5vdCBmb3VuZA0KICBz
dG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQ6IFBUUCB1c2VzIG1haW4gY2xvY2sNCiAgc3RtbWFj
ZXRoIGYwMDA4MDAwLmV0aGVybmV0OiBVc2VyIElEOiAweDEwLCBTeW5vcHN5cyBJRDogMHgzNw0K
ICBzdG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQ6ICAgIERXTUFDMTAwMA0KICBzdG1tYWNldGgg
ZjAwMDgwMDAuZXRoZXJuZXQ6IERNQSBIVyBjYXBhYmlsaXR5IHJlZ2lzdGVyIHN1cHBvcnRlZA0K
ICBzdG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQ6IFJYIENoZWNrc3VtIE9mZmxvYWQgRW5naW5l
IHN1cHBvcnRlZA0KICBzdG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQ6IENPRSBUeXBlIDINCiAg
c3RtbWFjZXRoIGYwMDA4MDAwLmV0aGVybmV0OiBUWCBDaGVja3N1bSBpbnNlcnRpb24gc3VwcG9y
dGVkDQogIHN0bW1hY2V0aCBmMDAwODAwMC5ldGhlcm5ldDogTm9ybWFsIGRlc2NyaXB0b3JzDQog
IHN0bW1hY2V0aCBmMDAwODAwMC5ldGhlcm5ldDogUmluZyBtb2RlIGVuYWJsZWQNCiAgc3RtbWFj
ZXRoIGYwMDA4MDAwLmV0aGVybmV0OiBFbmFibGUgUlggTWl0aWdhdGlvbiB2aWEgSFcgV2F0Y2hk
b2cgVGltZXINCiAgc3RtbWFjZXRoIGYwMDA4MDAwLmV0aGVybmV0OiBkZXZpY2UgTUFDIGFkZHJl
c3MgMjY6MDU6ZWE6YzA6NjY6MTYNCiAgc3RtbWFjZXRoIGYwMDA4MDAwLmV0aGVybmV0IGV0aDA6
IFJlZ2lzdGVyIE1FTV9UWVBFX1BBR0VfUE9PTCBSeFEtMA0KICBzdG1tYWNldGggZjAwMDgwMDAu
ZXRoZXJuZXQgZXRoMDogUEhZIFtzdG1tYWMtMDowMF0gZHJpdmVyIFtNaWNyZWwgS1NaOTAzMQ0K
ICBHaWdhYml0IFBIWV0gKGlycT1QT0xMKQ0KICBzdG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQg
ZXRoMDogTm8gU2FmZXR5IEZlYXR1cmVzIHN1cHBvcnQgZm91bmQNCiAgc3RtbWFjZXRoIGYwMDA4
MDAwLmV0aGVybmV0IGV0aDA6IFBUUCBub3Qgc3VwcG9ydGVkIGJ5IEhXDQogIHN0bW1hY2V0aCBm
MDAwODAwMC5ldGhlcm5ldCBldGgwOiBjb25maWd1cmluZyBmb3IgcGh5L3JnbWlpLWlkIGxpbmsg
bW9kZQ0KICBzdG1tYWNldGggZjAwMDgwMDAuZXRoZXJuZXQgZXRoMDogTGluayBpcyBVcCAtIDFH
YnBzL0Z1bGwgLSBmbG93IGNvbnRyb2wgb2ZmDQoNClsxXQ0KYXJjaC9hcmMvYm9vdC9kdHMvaHNk
ay5kdHMNCg0KLS0gDQpTaGFoYWINCg==
