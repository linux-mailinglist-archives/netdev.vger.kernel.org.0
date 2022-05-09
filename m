Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113C651FB9C
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 13:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiEILtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 07:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiEILtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 07:49:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183141D075A
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 04:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652096747; x=1683632747;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pO2a14cHXshvaYaQs+WD75K0qo14MliBs5VMJIJL32M=;
  b=ROUIsPORbcwFC4QUJpQRiB0zwT4nQCMDmu/0KAiXUixhWmBadck2DKdE
   sScoEuxfMXoIxc5eCkogpsbc4D/57x47c+hLYxe4G6raEO+yGPF6fl3ZY
   HoMY85QhRwp76pkUimRTOX5FOGBs0+Q4IsoHKEzqBlJaejC/f3gsDmaiD
   iHi85489sHTof42OmKyfRLSwMPcdHiEesmsMDX6JwWxdYcuHlTgrNe/cZ
   Abz5qltsSD6qP1+beXA+Eeht7LchSbNGJDfja2XLftspPYBYGu31M1Ykn
   XaHfmBr5TYXATtB3VdDnutf2VFjoyR5vE4lKRCt93KjA09+CrWWLC2LJw
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="155274010"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 May 2022 04:45:46 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 9 May 2022 04:45:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Mon, 9 May 2022 04:45:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4vdU1UYEI/hZpDBMcpevv/3jn5lF5hK98y8g5KZTNx2vLzyT0V3oiqj9A9NaSq/ssXEzbZPEDX3B34QOtSlcB+UB/UgYJTbTvadJTm4EhblQ7qdUtjLzbLdSsw8woqLFXYQWx4OaNJNsx3A2mg0pAIJGMCn76cl8OZF2vCIdhd1DwkQr3MfokHaoJFLMEWZXItcHJqqomHu8pnupzXRqzczhsUAiXBtBxWg74ffI1nCejw9Vbgs4nCJP1Q4QTGjpVpGPWikVOLDtHECUjXFfGg1+fW9forDC8OKtMH345z6xEdM8alL7OfVIyzFj/Sj/CsVByBAc9R5BAHGH7oizA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=apbBunZdsws6GAUtatMv6xBOcJDHRx9lJQpyhJeGLDM=;
 b=XWhqYXTyYiRLuzy/emBlO+mU2GyoCn6D6WYIAP++a8PK8CbSqygO5u/RweJUL8CxbauXtEavvNw7egLUWrMoiQ49GQVQTGTpJli394iZm4D+TTVxncEK+DVm+CEGSpDC8R/4ZwoiQC5uFpKUqswO4Q5RST6aWfNkwdJUmbS74OOqmD80N4ukGpZatigbeRyBbKhmsySUXKX1sanRxAadEcn5LEOccSTjs/quQJ2NL6pqc0KSNiBNhmDDYMcaq016ImRE7e5P5CSI9Mtj28/nAFnBkbtTibLrHVq+5QgPrqNog55PGYVMnpVLMl19mH2cXX5Jm8DFsG+XtTWEGSL7TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apbBunZdsws6GAUtatMv6xBOcJDHRx9lJQpyhJeGLDM=;
 b=qOu1c82zSHXlz/XQTKl9L1YWvaJBZSnbRYijnoZtUE95EO4CVYOceaGe6Yot5NumX+kFPIcDtBp5TlmX5aWu1UNHfQ/eh5VHTFmYq4WSnqEAO8HkcfpLU7CautPXvonzKk7LbBUqdo7P42UbEpq1TLGsRnH/c9f3AlmBxpA94jk=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by BY5PR11MB4118.namprd11.prod.outlook.com (2603:10b6:a03:191::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 11:45:41 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::251b:8192:8a6c:741b]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::251b:8192:8a6c:741b%6]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 11:45:40 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <kuba@kernel.org>, <andrew@lunn.ch>
CC:     <Woojung.Huh@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <Ravi.Hegde@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Thread-Topic: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Thread-Index: AQHYYKvOScev42KTZkuZEw3AktpFnK0Qq3WAgAHJGICAA/5ZMA==
Date:   Mon, 9 May 2022 11:45:40 +0000
Message-ID: <CH0PR11MB5561938D85478C47EE01D9378EC69@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20220505181252.32196-1-yuiko.oshino@microchip.com>
        <20220505181252.32196-3-yuiko.oshino@microchip.com>
        <YnQlicxRi3XXGhCG@lunn.ch> <20220506154513.48f16e24@kernel.org>
In-Reply-To: <20220506154513.48f16e24@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cf0e8c4-4a8d-43c3-40ef-08da31b17127
x-ms-traffictypediagnostic: BY5PR11MB4118:EE_
x-microsoft-antispam-prvs: <BY5PR11MB411807287059E024C9C011B48EC69@BY5PR11MB4118.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: carRGHvrgIxoYzV5CEQBZLINuQhxQceKM8P4SHQ+PshSoM04W+2g9rE52DqILTFMxkzeSjr0nWsWTNaTkbL4qb5rhJ4qsxOScMKEGz1BVjFgNKxuk///3FnFIKPnG94VTdc/2+Kf1RBqejEeo7rJpg2pPn9hXbJ4LVjLGEUKWuJubGSbbV7iRana8dTq3XtNg4zUbeJlBsx8HH2SdBqgwti+DHxhCU1+ytX9stkKofrL4pF9JnuTRZhc+qMwGcJsluNV+6vFjUIPkB1bbCo2Nrppy7uZQoP7wFBD7SXqTbqyKDITKG3VIK1LRqmN2G7N/Du2CRAB2nN73E+RKVnw58TEdZWZt9Es2qiSHOhYGdx9FxtrOXn49o1xWbRg5Uy6loX/QHZt/TWOdouNIop+M0K+hua1aI+tlMGHB1eeKHb5ui05I3Yl5BaMdDxqL/GlxKnFGHjPTskRcOhR5p9IQ1Qev8wE6uFEigDXimMPfIJDqu9JbpYQCaZE1Do7kfT9FnGNPzgebWceW+Ycm+kfu+gZH86EJ1cVFUkijHJFrfAZXrpTtVLvh5+EKm1d/RO5DOKmb/8qL8MCLkeoi4LPstYvNWwSxKaOstpCpfZDsy2kjithX7uETCMAGUR2m5K4ivHfYXgPjoNowOCWokqe4jhNeV/VPb6hfHV80Gae1L4hLtWpNA7ZKnuV00hzLZLUILyaGa7rK38K5drJn+NmxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(86362001)(8676002)(4326008)(26005)(9686003)(4744005)(52536014)(6506007)(7696005)(2906002)(122000001)(83380400001)(8936002)(316002)(38100700002)(508600001)(33656002)(38070700005)(5660300002)(55016003)(186003)(66946007)(66476007)(76116006)(107886003)(54906003)(66556008)(66446008)(110136005)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6FZnGimdqs9oJSuyD8nMCcaocuCP1JT48P2CPlUwmQFIfZNR4ZPpZG3WEf6D?=
 =?us-ascii?Q?KnP0pDHSNX2cmNOUi8M7/m4vUSq9MnF+FDrrVq/9jSd8DT+9etkFiFWVp6/r?=
 =?us-ascii?Q?oiikJ5RyX77h5NAjEnHMu/z4NseTvxjJVH2q3TCka5GEbu1oOIyTao0gCz9Z?=
 =?us-ascii?Q?Rc7Xhv6t/86KJz08PQhUPtYQf8Q5fIFGk0SLV3h7KsmMpXp69Nca4a8rUcJM?=
 =?us-ascii?Q?mrvHhEHB1KR8H4XA+zBMLmvEkcMLD7Dz3JbWQ6QmNDMhYwKXe/qT6At3ZG6d?=
 =?us-ascii?Q?bg2vMB6l0+yIeepROTIXtgEkWxenkKEeYocjy4Sszatb6wTrpD9uUEGquq2f?=
 =?us-ascii?Q?/y2EWDgA8RyonzpC/KjTwkBELyE/YPCRqAV9qCuo4ztq5c/2uYGqk9LuCeV4?=
 =?us-ascii?Q?kPpCC9im/BmMnxzjh9wS9qdf3Z7Iswh7TytngPCeOsfzZx9+F0OYM5PDYUXK?=
 =?us-ascii?Q?sLMvYEB1xiLIU2EcIOVI9FskOpxPdjT4H/Icngk029Uhy+3YxV8jTAcxcIlp?=
 =?us-ascii?Q?xsX7749IkvjVp2aVV9kiirM9b51kqILk4lPB/zJoMHHeBR8hS7IwA0wR76z5?=
 =?us-ascii?Q?aY7Z8MrmfjkLtVtt1MBIMx32bWq3NHOCzUNIORs5DOF7rZ2Qb4wL2Q8+GO0D?=
 =?us-ascii?Q?8HPggx2wYFvnA88P/KyEBESHScI/mYYPUv+f+kt7wH45sU6yIQoYIvDjzKdm?=
 =?us-ascii?Q?7E/bpF/a8MjSO6tx2UH/DDaje5lnP4GKAZLWahcWoDZFjgFWzdMW0io2yhO1?=
 =?us-ascii?Q?crNNuEuHxiTboI7zoVFbfPJTD/ZcdgbkNVlctaVS3XEY7tkeA2fnBxsI/+zS?=
 =?us-ascii?Q?nEs1Xct7zRC+jAse3aATxG9gRNgyle6dBAF5JQ5QLAOjDzf2HjxrFiOAqFzx?=
 =?us-ascii?Q?Us6+wI6GSY6Oq3jv4ZnFRQiOfDYspde+txyKpXdl7p9CJeuc/wiWFITZLEdN?=
 =?us-ascii?Q?sUMda9tZJGPDccPfsGy+JDbHz2ZzxgHCjtGbHez7D9K4W6erWL1bpGQe5unW?=
 =?us-ascii?Q?+Yo6LSvpaxE0U7FhLWMJKuPlELAx0OsYd3LEWlyi4qQ8r4dm5V8mi9nwS8a/?=
 =?us-ascii?Q?bk4PZBuiGoAWpL+W9rPNvgToiiKwdMLeiBCK0TY5+IyZQVZ0tiFk9FXSAnTY?=
 =?us-ascii?Q?mh5gEVi7PXMcbGWTae74GzFwKrV0D/oB54MB4TPZd6gtRFRrFpiAdgGyt6mf?=
 =?us-ascii?Q?XTHHXYXXSWspFwK2XZoG+Qgj8sMbPHYZ5oBlQhvixOnZVA3GA3WLOnsPavQ7?=
 =?us-ascii?Q?RsQ+6OtrDKpPKN/PJSzZxGcNcHSp10kmQQ4ca06EhAACLS0PwCsRCC3+Ktgc?=
 =?us-ascii?Q?uGVVAngXn96OrRh4G87U6D7NMBb0kpb3F0LftstRo1nme+yzxwS7UeTgYHNg?=
 =?us-ascii?Q?Pd89UtVpC9CiS7I/2y7yhErerABeyZPmQesnoCgAIKZbIXoCxm0VmzfqERbu?=
 =?us-ascii?Q?m3xU32N5iLiq3j09kUtd4pWtH3N9v2f7H0tQMOXpTw/Hhoh54iEO7HO69rCh?=
 =?us-ascii?Q?t/cfylIjoL1bvGZUQbjU73ltnJ7zvrKA9YTSngDFgnBEKIE7F37CxNfg29AV?=
 =?us-ascii?Q?w0if+bLGBaqlpfGHkHRFpKrZRKMw0nLocMbkDV0mD+yfayQsP7F1RLd0Ae3N?=
 =?us-ascii?Q?oBMdYE+4vPxwBch3Vm4jKew/5rZY824kG+IRtsOzMhAzZM9DMTb7z33GUy9x?=
 =?us-ascii?Q?f0aym2fgjAprA+kppGx4YitwIVNnvnwbIwaY/G6RQ+g+6WPHPHzLj4tEv5FJ?=
 =?us-ascii?Q?qs6miPQAl8Ts8EA6s27eGgUnCoHu6L8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf0e8c4-4a8d-43c3-40ef-08da31b17127
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 11:45:40.3561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FL2W6pCuNJ7+AYuArEEcWwD+DPAMFoToIUkRTct8gzOZayQxFYDtmPjihH1nro1wKf7ZgxxtzGcN5vWB3LyOLSlzbrKXU+EBBPEH/71pY+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4118
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Friday, May 6, 2022 6:45 PM
>To: Andrew Lunn <andrew@lunn.ch>
>Cc: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>; Woojung Huh -
>C21699 <Woojung.Huh@microchip.com>; davem@davemloft.net;
>netdev@vger.kernel.org; Ravi Hegde - C21689 <Ravi.Hegde@microchip.com>;
>UNGLinuxDriver <UNGLinuxDriver@microchip.com>
>Subject: Re: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy suppo=
rt.
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>On Thu, 5 May 2022 21:29:13 +0200 Andrew Lunn wrote:
>> On Thu, May 05, 2022 at 11:12:52AM -0700, Yuiko Oshino wrote:
>> > The current phy IDs on the available hardware.
>> >         LAN8742 0x0007C130, 0x0007C131
>> >
>> > Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
>>
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>The comments which I think were requested in the review of v2 and appeared=
 in v3
>are now gone, again. Is that okay?

Thank you for the review.
Sorry, I will fix it (add the comments) and re-submit.
Yuiko

