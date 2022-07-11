Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B510570D2C
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 00:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbiGKWGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 18:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiGKWGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 18:06:50 -0400
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748DE52DEB
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 15:06:47 -0700 (PDT)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BM1cFs015790;
        Tue, 12 Jul 2022 00:06:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=message-id : date :
 to : cc : references : from : subject : in-reply-to : content-type :
 mime-version; s=12052020; bh=NublwtPrNI00oy1H6V9PN4Qu4jjYGU2GPTy0VoKR8JY=;
 b=W7A3cVtWMBFXw09FbSTd47paOHgWwguHfHa4FCHhiljUxzt56bfYpsMTzgRD4TJbpjNH
 jTMNohFZo02DleLjNyT0IndGE+6NLMK7paVEtw+ABFk6Veqde8DiP9thsc9WvoLD2KzT
 Oqv386hcRMAQBKST5+jtNA0Vj/YhX/G1kcJxVVDCKDXJRZoGiEMsNif3LhjtntdLzDCI
 GeZz2idXNyKG7DDaJ9lv2we2AnWnGlQOZ/eAkyV4hTxJOw1GEQpRdgs/FGkiuNsO7XgC
 QvDKlEeKcQgQcR6jH/1A1QWcm9ApC8QtcBh8loV8gx8a33doXTjc2L2jLJCI8zpVVAr2 mw== 
Received: from mail.beijerelectronics.com ([195.67.87.132])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3h6x1camcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 00:06:21 +0200
Received: from EX01GLOBAL.beijerelectronics.com (10.101.10.25) by
 EX02GLOBAL.beijerelectronics.com (10.101.10.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Tue, 12 Jul 2022 00:06:20 +0200
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (104.47.0.51) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17 via Frontend Transport; Tue, 12 Jul 2022 00:06:20 +0200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDOEfv/7XCHA1TIl/fwGIp5xUCU4Lb1H7662s2VA+IAhDbhk8Jk8ospfMmJs3LfU0cp/rfPAAGY8te5CbyPJ74vlLe7DR6+VEMRT5rFw6ucQ1E1Y5ccaYWgr+68F9jTyaRFQXYQ+kl9Of3TmUSUXWeoULUeXU2dvR/KnxwHkxm1ftejnqYhCkuwCo1dpUtXETs4m67VPU6titfhXzMLThpVLLMjXw1mMNoA+WttzwzsW7hT45dBbLkUsuk+UjYbYK2tRRrw938Zb7bSqZZ8NODs/3X8JkFzxgFzgoigmLBrrVCjEWMg8xERmGEhLzo/zm3dMIKu0L5RudzdPLSOIIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NublwtPrNI00oy1H6V9PN4Qu4jjYGU2GPTy0VoKR8JY=;
 b=euGxj0N+miKePy/YPIpxG/PvlpsoFGToR9y6PEWR84LJ0HqUNlz2FQ7MxCk5XkwIWTXDc1teGW9Emap6I6fXy8EduvWvtlTIXv8FBAKPO9ovQwD4x9pY4oXABNhliBCLQnIYBegZl/ykSO14PPLNFRWKltFShsVoO+S84nCSBupv3piEax3gTC3f2s7RRcw21/XFfkJAbIvyWc4IjzqWEnw26JlGxIES9ia1xEgTIldxMg1dnZZeKiS/8A/A5ikBXXSA6c+yktNPF7shFl8h/v8tj47f1uudJXU+ertpTA+bu23BDx9fY9sNLS0Uh9rixsjJ2ezkMz9YbK/K152NTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=westermo.com; dmarc=pass action=none header.from=westermo.com;
 dkim=pass header.d=westermo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=beijerelectronicsab.onmicrosoft.com;
 s=selector1-beijerelectronicsab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NublwtPrNI00oy1H6V9PN4Qu4jjYGU2GPTy0VoKR8JY=;
 b=H9g1KMmF2BlhoFP4udbnrqcPncAPaqhImy6CObhAV2S17t9RHU6wSDD3Ph4q7dPefPniG7ATaCc7pDC4s9/GvwOVWNRHJVG/z1yFf/Rc1oahoLQvoksjxxETa2v1m3i3Sq2oTte9eIYsLyhv0+5WBsRbvnbgjDWKKfVgeSrzIK0=
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:296::18)
 by DB7P192MB0521.EURP192.PROD.OUTLOOK.COM (2603:10a6:5:8::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.16; Mon, 11 Jul 2022 22:06:18 +0000
Received: from DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d]) by DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 ([fe80::19e0:4022:280c:13d%7]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 22:06:18 +0000
Message-ID: <331695e3-bfa3-9ea7-3ba9-aebd0689251c@westermo.com>
Date:   Tue, 12 Jul 2022 00:06:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
 <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
 <20220707170145.0666cd4c@kernel.org>
 <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
 <20220711112911.6e387608@kernel.org>
From:   Matthias May <matthias.may@westermo.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
In-Reply-To: <20220711112911.6e387608@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------URdnugFwJ7xXV97TBN0hfWSn"
X-ClientProxiedBy: GV3P280CA0075.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::24) To DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:10:296::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b0874a4-a898-4deb-a782-08da638994cf
X-MS-TrafficTypeDiagnostic: DB7P192MB0521:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OfcyVPo2uEPplLgvNc9EEt0LVLwr4gR8BhJV1mAusSWh1GzUs7FWo3qHVyJjrQkmVBZ6V+4sBR09zCr6qFcGKXv4EDJzV+suKJtSo3PzSEbfjRp/x1GARk8IUaLjbq6Z2sgJb945S820CTsIkJv85LkqAq1xSq5njPF17tkS4U5lRoBd2z6fvV5fR1ZoJdi0FWVXjI8tzNmMlrAIG5HbdjBS+43gb2sS8vGrXkwAb1ZozatpVA4g4RoRrXaS2mQT8c4qZ/jtfDQdVBM7PkKyq2L2zKLELQaisdv74r958wJEjsvF5tARrTgyKyFbqDLQGej/lNjj7fBd/gCk/FyL2UvtN452Idfp+6UPelf4pcCi6SfkXD/c44J/Edi8mff7hyYq5277+meW29i8kqHx5St1jUDaCVkbPukI83fVh73FTWPeWTep3Du4Rl7n1kSmleYzQjYmI3XngL4Oa59SuhcoRl2VN8mTgZksWp7ie1fxojzIHAlwwejlY7pHPVGqMLRYXm3IUS/VDvgAPFEX45SIOZ9Mn8IQ1lQERP6PdftskvyH+QX1ZauN48Sc11jcDJQPyS0g4EX5w0ryV80stM0OMMJY3t9yJu54S6RydDWQ8VXbXNZsfuuv/coNP76FpRovJHAGTu9NT3yhLkISg0VYjjhW+zL1lUSLW6KohUz2Pge8GCaOkYKRQ8MdXTDkW5qyFQr0sTUjXdXYbzjdVs/u0fpOCpjCvETOVLfDZNI/HW6Y3dTdxU4Du26aQUqxtO21jHlbvEqBjMa75WATPlQawMtKeNXQs2XlWfHeM7avG6xERmbaWnf7IKPjDlB89+pqqYDaCrvhPmQVtKq8Tx42B5J6DlvTdAf7JXU8+unEdY1h5nPQ1jYUNuwLCGJo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9P192MB1388.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(136003)(39840400004)(396003)(376002)(44832011)(31686004)(5660300002)(2906002)(235185007)(36756003)(4326008)(8936002)(66946007)(66556008)(6486002)(316002)(8676002)(86362001)(6916009)(33964004)(2616005)(21480400003)(6512007)(186003)(41300700001)(31696002)(478600001)(6506007)(52116002)(26005)(83380400001)(38100700002)(53546011)(66476007)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WndUaVhFSzR1MDd4VGtqTTYzSmRQMWMzOVZYaFl4VEkyak9mdnNQdEx6d1Nk?=
 =?utf-8?B?NTZxUTRFMC9QSmdUSGpiU0psNXRKVHBlQnJCZUp0ZTI0eW4rS2xqdFJRVjRj?=
 =?utf-8?B?Unc2Q1JodkxNUDliV1J6aUpmcWY5OS82Um1XcW9zWTgxSnZjZGdFUnB1ci9k?=
 =?utf-8?B?OXNZRjlWR1I0ZVlLSWY2TDRvOWZjVWRqaGhxcEd3cEppbW1vUVFqcjFvT1RR?=
 =?utf-8?B?K1kwK2kxd1J3QmxsR29vYVNMVFBIR3QwVzVqTmMyY1NJdHZSSzdzMXRCVmp0?=
 =?utf-8?B?bVVVdkExOWtQNjZOVU9zUzA4dkVZcnpidWthUlc1QW1FL3BKT1ErS1Bqa2VF?=
 =?utf-8?B?OXFBcmZFdncyeUhZcEUzc0dJRUd6WkdtN1RaODVWeUhYNU1RSmVYSGxlSDc2?=
 =?utf-8?B?ZnpzcUR2bE9jQjJPbHdOL1Y0QlZJOWtRWUJEYmZTSGc4U2xWQjdEaXBMTnpR?=
 =?utf-8?B?b0tNSXhCanV4T1JUdUFxMTVGWTJGM3VSRW16bWZ1Qml1YVdBSndMNWc0dmhG?=
 =?utf-8?B?ZWcxZnBJZW14MGRXN0RsTWp0cCtrN0tGSlIvME9jZjQ1cGVqdTVFMXdzWThZ?=
 =?utf-8?B?aFA3RmFUVEFmdDRiZUxqRFlCM0E3V2l1bTlrZmlnTFFBd3hGeENIMWo0OVRX?=
 =?utf-8?B?R2tVUVM5ZURNa0JpY2dtbjhJbmg5MVpDMXlya2RIeno2VzdJdkVGbksreTVN?=
 =?utf-8?B?bUxRTXB3SUpkVThHem1pZVJ0cERaVzNLY0FOYmg3ckgvZ0tOZXdGdWNGaEhs?=
 =?utf-8?B?aSsrYXRKVysyY1pEd3p2SGlNWjY0clV0V0d6NDVMYjRraVBzOFlPekFmWFRW?=
 =?utf-8?B?WExLZVNJQ3h6ZG1JT2FwMXVRTm5pZzJ5SVh2Uy9hQk1jaC9wVmNXTCtlbG8v?=
 =?utf-8?B?bVorK09ZSUdoa0R1Vm1senhHdkQzWnM5SFFlaDR0cWU3anhuQ29TWk4zRzBo?=
 =?utf-8?B?QjBTcUREKy9qckFoN2YzSHFPNG5HZVJSeEU4UnlNNnFET3ZSTzJxa2IvcG5E?=
 =?utf-8?B?U2ViZEZhRmcxMnR0S2I2WktXOFJlRHZnejEvS1BiRGVMMGFlcW80b0RheWU3?=
 =?utf-8?B?WmhEOHVXZmhRWFBtWE9wWHdDWDk1V0ZjQzN1eXhGd1FhRFZhOU9ndExHWkJH?=
 =?utf-8?B?TlpxU29NMnV2TkpCNEEydkNjejBWckFpOGxuRnRlY3krM1BqWUxQS0ZYRFlG?=
 =?utf-8?B?akNMdERrU1lwZHlSVGVqVVRWTVlEQVMzcVZlNitZbzFxVndadmlyQW9laGgx?=
 =?utf-8?B?TndiMENEOTBtbFVOWWdoWWhWaUJkeWNVcEUrdHEyWEpBTlhLWWgvKzBKMkFm?=
 =?utf-8?B?dXRveWx0azBkc2J2enZJZXN2ZTVpaUVRaFoybldYdnhGR3R6SDVDZWtGd3BB?=
 =?utf-8?B?SDd2cjYwVERueDZhbkNPUjJUMXJ0d2lrR29iODhnTG9ldWN4TVA2eFZnUVd3?=
 =?utf-8?B?ekJHdGVybWFLMi9kS29TQUZOeUVRMzAyM1E3Rm9SaXpKV3Y0R3lpdW9aSnkv?=
 =?utf-8?B?NDA2NGkvZjlDVXhRNWVJUC9tQWhmczMwMm81d3NkYVhZQXlzclJIVjB4NU5p?=
 =?utf-8?B?R3BKbTNiZTVJVFBPdW9nMVpuTklZSnl0N0NWc3FnaThFQ1NMckZPVHRQZk1U?=
 =?utf-8?B?RXdUQkFKNzgyVWJEeDh0eUhEcXAvSU1hL3djeGdteGRhS1ZxVk5ORldlMFZs?=
 =?utf-8?B?c1NzakZFZWVxdTE0Qkczb29OeXhVV2pjTmQxSzltcE5vWWZKV0lnWFdJTXha?=
 =?utf-8?B?aVNIN3Y0a0tydEtzNkIrbFVRcGdSSGRRY3NrRjVSMVZPMVkvNytnZk5aa2ZS?=
 =?utf-8?B?Uit0SnRvbEpqaDJxMDgyQUZKR0puYngvUDZ2NGhxZDhGR0V0WTVQWUxSdG5v?=
 =?utf-8?B?eVpjUENBK05TU0R3REVVZG9rU3MySThJMTVnQm1yQjFDWG9IVlp1bFMrdHQz?=
 =?utf-8?B?SWtKcEFUUUlNUmduMTk5eGFPcGs2ZGdXOGRNOVR1V01BYTk4Y016UyttS3Zw?=
 =?utf-8?B?c25BYUJ4TndBWDBRMFhEajdkQ1A3UExSSDdyQThkZmZJZVRodzNza1F4VHhh?=
 =?utf-8?B?QmlsMHFRWnRCZTZJWEIxOGl4NXpvdWtEdXJBQ3NjZ0pnbXZTT24wRXA3RFMx?=
 =?utf-8?Q?7j9B2nYOKeUJ3DKC/DsaQxkBM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0874a4-a898-4deb-a782-08da638994cf
X-MS-Exchange-CrossTenant-AuthSource: DB9P192MB1388.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 22:06:18.5903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4b2e9b91-de77-4ca7-8130-c80faee67059
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zsbuhfFwZvh5+6OJp4ENfMCIkLf0hisioN+nawBp81UKDXznJsmI+dbt2HR3t6sCuXl+AJCxGRLmZnXa4r27gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7P192MB0521
X-OrganizationHeadersPreserved: DB7P192MB0521.EURP192.PROD.OUTLOOK.COM
X-CrossPremisesHeadersPromoted: EX01GLOBAL.beijerelectronics.com
X-CrossPremisesHeadersFiltered: EX01GLOBAL.beijerelectronics.com
X-OriginatorOrg: westermo.com
X-Proofpoint-ORIG-GUID: 8zKyytLY-6tKlKSAkuuRraaicW1JWizX
X-Proofpoint-GUID: 8zKyytLY-6tKlKSAkuuRraaicW1JWizX
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--------------URdnugFwJ7xXV97TBN0hfWSn
Content-Type: multipart/mixed; boundary="------------at0kTp0HEuydtFA9bg2zGFAx";
 protected-headers="v1"
From: Matthias May <matthias.may@westermo.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
 dsahern@kernel.org, edumazet@google.com, pabeni@redhat.com
Message-ID: <331695e3-bfa3-9ea7-3ba9-aebd0689251c@westermo.com>
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
 <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
 <20220707170145.0666cd4c@kernel.org>
 <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
 <20220711112911.6e387608@kernel.org>
In-Reply-To: <20220711112911.6e387608@kernel.org>

--------------at0kTp0HEuydtFA9bg2zGFAx
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTEvMDcvMjAyMiAyMDoyOSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFNhdCwg
OSBKdWwgMjAyMiAyMjowOToxMiArMDIwMCBNYXR0aGlhcyBNYXkgd3JvdGU6DQo+Pj4+IEhv
dyBzaG91bGQgaSBnbyBmb3J3YXJkIHdpdGggdGhpcz8NCj4+Pg0KPj4+IEkgdGhpbmsgeW91
ciBleGFtcGxlIGFib3ZlIHNob3dzIHRoYXQgInRvcyAweGEwIiBkb2VzIG5vdCB3b3JrIGJ1
dCB0aGUNCj4+PiBjb252ZXJzYXRpb24gd2FzIGFib3V0IGluaGVyaXRhbmNlLCBkb2VzICJ0
b3MgaW5oZXJpdCIgbm90IHdvcmsgZWl0aGVyPw0KPj4NCj4+IFllcyBpbmhlcml0IGRvZXMg
bm90IHdvcmsgZWl0aGVyLiBUaGlzIGlzIHdoeSBpIHN0YXJ0ZWQgc2V0dGluZyBpdCBzdGF0
aWNhbGx5Lg0KPj4gSG93ZXZlciBJIHRoaW5rIEkgZmlndXJlZCBvdXQgd2hhdCBpcyBnb2lu
ZyBvbi4NCj4+IFNldHRpbmcgdGhlIFRPUyBzdGF0aWNhbGx5IHRvIDB4YTAgZG9lcyB3b3Jr
Li4uIHdoZW4gdGhlIHBheWxvYWQgaXMgSVB2NCBvciBJUHY2LA0KPj4gd2hpY2ggaXMgYWxz
byB3aGVuIGluaGVyaXRpbmcgd29ya3MuIEZvciBldmVyeXRoaW5nIG90aGVyIHR5cGUgb2Yg
cGF5bG9hZCwgaXQgaXMgYWx3YXlzIDB4MDAuDQo+PiBUaGlzIGlzIGRpZmZlcmVudCB0aGFu
IHdpdGggYW4gSVB2NCB0dW5uZWwuDQo+PiBTaG91bGQgaSBjb25zaWRlciB0aGlzIGEgYnVn
IHRoYXQgbmVlZHMgdG8gYmUgZml4ZWQsIG9yIGlzIHRoYXQgdGhlIGludGVuZGVkIGJlaGF2
aW91cj8NCj4gDQo+IFllcywgbW9zdCBsaWtlbHkgYSBidWcgaWYgeW91IGFzayBtZSA6Uw0K
DQpZZWFoIGkgdHJlYXRlZCBpdCBhcyBzdWNoLCBhbmQgc2VudCBhIGZpeCB3aXRoIHRoZSBz
ZXJpZXMuDQpJIHdhc24ndCBzdWNjZXNzZnVsIHlldCBnZXR0aW5nIGEgc2VsZnRlc3QgcnVu
bmluZy4NCkkgaG9wZSB0byBnZXQgc29tZSBmZWVkYmFjayBvbiB0aGUgcG9zdGVkIHNlcmll
cywgYmVmb3JlIGkgZ2V0IHRoZSBzZWxmdGVzdCBydW5uaW5nLg0KRXNwZWNpYWxseSB0aGlz
ICJidWdmaXgiLCBJJ20gbm90IHJlYWxseSBzdXJlIGlmIGkgZGlkIHRoZSByaWdodCB0aGlu
Zy4NCkVzc2VudGlhbGx5IGkganVzdCBjb3BpZWQgdGhlIHByZXBhcmUgZnVuY3Rpb24gZm9y
IElQdjYsIHN0cmlwcGVkIGV2ZXJ5dGhpbmcNCm91dCB0aGF0IGkgdGhvdWdodCBkaWRuJ3Qg
Zml0IGFuZCBjYWxsIGl0IGluIHRoZSAib3RoZXIiIHBhdGguDQogRnJvbSB0aGUgbWFudWFs
IHRlc3RzIGkgZGlkLCBpIGNvdWxkbid0IGZpbmQgYW55dGhpbmcgdGhhdCBpIGJyb2tlLCBi
dXQgSSdtIG5vdCBzdXJlIG9mIHRoYXQuLi4NCg0KT25lIHRoaW5nIHRoYXQgcHV6emxlcyBt
ZSBhIGJpdDogSXMgdGhlcmUgYW55IHJlYXNvbiB3aHkgdGhlIElQdjYgdmVyc2lvbiBvZiBp
cCB0dW5uZWxzIGlzIHNvLi4uIGRpc3RyaWJ1dGVkPw0KVGhlIElQdjQgdmVyc2lvbiBkb2Vz
IGV2ZXJ5dGhpbmcgaW4gYSBzaW5nbGUgZnVuY3Rpb24gaW4gaXBfdHVubmVscywgd2hpbGUg
dGhlIElQdjYgZGVsZWdhdGVzIHNvbWU/IG9mIHRoZSBwYXJzaW5nIHRvDQp0aGUgcmVzcGVj
dGl2ZSB0dW5uZWwgdHlwZXMsIGJ1dCB0aGVuIGRvZXMgc29tZSBvZiB0aGUgcGFyc2luZyBh
Z2FpbiBpbiBpcDZfdHVubmVsIChlLmcgdGhlIHR0bCBwYXJzaW5nKS4NCg0KQlINCk1hdHRo
aWFzDQo=

--------------at0kTp0HEuydtFA9bg2zGFAx--

--------------URdnugFwJ7xXV97TBN0hfWSn
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQR34wKNh4Jxr+4dJ/3fdrYEUzwNvgUCYsye2AUDAAAAAAAKCRDfdrYEUzwNvr3Q
AQCN6m68v0IB4sUmitKzESUvW15ygO0evG9sGO6jpyoujAD/XSkeuZVd+dQimdfGuelS9+gz8LmD
cmAw3iGf/lnIMwA=
=vyln
-----END PGP SIGNATURE-----

--------------URdnugFwJ7xXV97TBN0hfWSn--
