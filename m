Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340744BF3B3
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiBVIdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiBVIdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:33:23 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Feb 2022 00:32:58 PST
Received: from esa2.hc3370-68.iphmx.com (esa2.hc3370-68.iphmx.com [216.71.145.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983D8C4B57;
        Tue, 22 Feb 2022 00:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1645518778;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=8ECoz0hKxN6wB0prEA2JUvM7foOV7eNJF7DEQ1CBcPo=;
  b=QQal83MbuS8mtRJb5Lw+xX2DZ5rxFb9qeaI154fNt5esSf/KJILG6spi
   emKkWLuhW6GWv6rTB3MVS0Nag+sFLrbq3HX4WOZA0h6PzVXYkMREixvD1
   xorct0AEJG6Wi7RxUPtjQR6mm4xiyIn5v8s7TNiYchctvSlv3nKaqfh+F
   w=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=pass (signature verified) header.i=@citrix.onmicrosoft.com
X-SBRS: 5.1
X-MesageID: 64703492
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:1dA6L6JS5VF33+6hFE+Rb5UlxSXFcZb7ZxGr2PjKsXjdYENS0DQCn
 WJMD2yHb6mLZmOjctB1Pojg8UNUvZKHz4Q1TgJlqX01Q3x08seUXt7xwmUcns+xwm8vaGo9s
 q3yv/GZdJhcokf0/0vrav67xZVF/fngqoDUUYYoAQgsA180IMsdoUg7wbRh2NQy2YLR7z6l4
 rseneWOYDdJ5BYsWo4kw/rrRMRH5amaVJsw5zTSVNgT1LPsvyB94KE3fMldG0DQUIhMdtNWc
 s6YpF2PEsE1yD92Yj+tuu6TnkTn2dc+NyDW4pZdc/DKbhSvOkXee0v0XRYRQR4/ttmHozx+4
 Mty6LqpdSUAB5zzsr4bD15oOSBEF5QTrdcrIVDn2SCS50jPcn+qyPRyFkAme4Yf/46bA0kXq
 6ZecmpUKEne2aTmm9pXScE17ignBNPsM44F/Glp0BnSDOo8QICFSKLPjTNd9Gls2ZgVQaeED
 yYfQQFUdimHejRAAxAwA4gsnue6lGfWKTIN/Tp5ooJoujOOnWSdyoPFPNPLd9miScxLk0Oco
 WzauWL0HnkyLNWCzRKV/3TqgfXA9Qv4RYgbPL617PhnhBuU3GN7IBsbSVe2v9GnhUOkHdFSM
 UoZ/mwpt6da3FymSJzxUgO1pFaAvwUAQJxAHusi8gaPx6HIpQGDCQAsSj9Hdcxjt8IsQzEu/
 kGGksmvBjF1trCRD3WH+d+8qDqoPCEPIGwqZCkaTBAE6d3uvIEyiB3USt9pVqWyi7XdAi35y
 TSHhDYxiq9VjsMR0ai/u1fdjFqEuZXICAo0+y3UU3ij4wc/Y5SqD6St4lKAtd5BNJaUCF6bs
 xA5d9O2tb5US8vXzWrUHbtLTOrBC+u53CP0n2EyOYAd1R2UykGJJ4YMpwFUJX1DC5NREdP2W
 3P7tQRU7Z5VGXKla65rfo68Y/gXIbjc+cfNDa6NMIcXCnRlXErepXw1OxbMt4z4uBV0yckC1
 YGnndFA5JrwIYBu13KISugUytfHLQhulDqIFfgXI/lKuIdyhUJ5q59YaDNijchjtctoRTk5F
 f4FbKNmLD0FDYXDjtH/q9J7ELzzBSFT6WrKg8JWbPWfBQFtBXssDfTcqZt4JdA4w/oEy7qSo
 ijlMqO99LYZrSecQeltQio+AI4DoL4l9S5rVcDSFQzAN4cfjXaHs/5EKspfkUgP/+1/1/9kJ
 8TpiO3basmjvg/vomxHBbGk9dQKXE3y2WqmYnr0CBBiLsUIb1GYpbfZkv7HqXBm4tyf7pBl/
 dVNF2rzHPI+euiVJJyIMKn2lwvp5xDwWotaBiP1HzWaQ221mKBCIC3tlP4nZcYKLBTI3DyB0
 AiKRxwfoIHwT0Udq4ehaXysx2txL9ZDIw==
IronPort-HdrOrdr: A9a23:fm6rjKhLHOF8QC3j4ROq6RqHqHBQXt4ji2hC6mlwRA09TyX+rb
 HIoB17726RtN91YhodcL+7VJVoLUmyyXcX2+ks1NWZMjUO0VHAROsO0WKI+VzdMhy72ulB1b
 pxN4hSYeeAaGSSVPyKgzVQxexQouW6zA==
X-IronPort-AV: E=Sophos;i="5.88,387,1635220800"; 
   d="scan'208";a="64703492"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRA8TnYsZFZsJj9VD5at8Znpn1W1EGg0YE+MmUBQFvyfcHx5i77+Mlhlh0dzZp3mYwWo75YEbQ/z9K6qNur5LwrGZGb9bK34A5meOEtxrlNOZQ9Hh7GiVgxGdClxyUCYEWI1SUwtpHMBDBmee1p0oKGhng1WwV0gksOzE6weKfwfBVvi+YA0uuUOPtNQ3IaiuPMfJ6zhk53F2fhTk4lEgPWwRK1JDZhAhD0AL1WQOD+imFiPAEV8En1po6zUIod8g8+CpvhAZvD4cLgHZGlCBirjdA/RAzaJ3Mf1m36O0XmU70erTEj546WGBI/fsCKxl6FGSCpjJCjBMYJshz2NeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vE18hdZ9uVAnGW50XqiQx6/cqbsWACrD6meOYQdWLa8=;
 b=iSkkgr0dJJgtJz2/CzKnmzUKyNwHYOg7UTAAAQDZiszYcXLaWMX8lBfccHqisn1+R6DiBIPloB5lEtxFgUsorEfIHallqnOytqZDHIEpuPzES3Jj2jmU1pnHsDEs/x6XaCXF32tCW46cSmoc6y939eRIHvSTtm5f7axla5lGuR+j4doPEY/H1LHLp6WFU+9DlNd18XzbND9YfrKS49uMMse/H5E/ZNfIhLUEa8kqxM0sDFEWwRFSOJsLRN6fDhJJ6y9oDC714ZPPqX5J6CuTLBeIDErgA2+A0XdK8LJHUwUShKJCfdw5uuq128NGkOKhJu5J4q3BNCE83CEmPiDsiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vE18hdZ9uVAnGW50XqiQx6/cqbsWACrD6meOYQdWLa8=;
 b=xDOJD/pggOWKI2RhnfMs/AreKM6V+cZtBwn0R1YuLT8h+xC77aEgnTjFQiAWEB9UWsb9RIMBZ2mL1hp8PrOLvyd/Cej1CNIFYfMQ03nzODnxBEa8Uyp9+8PvO3jNDcw9SviEWDfk4pxIxJ/k+k96YTGVaNDjQsZBVPMhFTF1gO8=
Date:   Tue, 22 Feb 2022 09:31:31 +0100
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Michael Brown <mcb30@ipxe.org>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:XEN NETWORK BACKEND DRIVER" 
        <xen-devel@lists.xenproject.org>,
        "open list:XEN NETWORK BACKEND DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Revert "xen-netback: Check for hotplug-status
 existence before watching"
Message-ID: <YhSfYyh3xU4HZKek@Air-de-Roger>
References: <20220222001817.2264967-1-marmarek@invisiblethingslab.com>
 <20220222001817.2264967-2-marmarek@invisiblethingslab.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220222001817.2264967-2-marmarek@invisiblethingslab.com>
X-ClientProxiedBy: LO2P265CA0183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::27) To DS7PR03MB5608.namprd03.prod.outlook.com
 (2603:10b6:5:2c9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b16ef669-15ab-4cab-f397-08d9f5ddbe0f
X-MS-TrafficTypeDiagnostic: BN7PR03MB3777:EE_
X-Microsoft-Antispam-PRVS: <BN7PR03MB37779DA32F03C93B322DB5A78F3B9@BN7PR03MB3777.namprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 94j9Q1EY1Xj2FcJrricYavncdfA9i1E7cIhXV9ABXsUvOlzGbdOQjhsyDSsuUINo1W26RjgtNFxSEw82NW5WXFXq+oQ/ycCmVk0AeDg4aqrPHhGOo5KWHr4cAS+tvzr7Z230MecT675r/cYTJoFdEWg/mRM5UaZk7wjMLPGU0gvMzZhR+DS4zWwG3TRZg26ckefNrGlQvYpvfgjdOhnebLrfhvrp16lXfh8R9N7znAGe6bzQXtYWusmwPNV+zB18++0EWhxnSBQwI47eFfNM9CCTJ246jgaJCW5dAdGILok2d467CczilX9YSiomGqor6Q3CMqfnzb9u/pC8QZ2s+yPQ1DmGSyp5PlJO4fbQ7K/S3fZ7EJnar61QtIxR83V1ikmIxaLhB2kTTtLqzNIpTVeG6h4dIgoPoFj7rV9LKBFwymq6SpmxYyim6HKWt/3h9qS7PJczC22YITi6nkuC2I31BDU3d4FI46TiffrAjgTmooZQO3MU+uXG8u5OIwilaDORXmWqQL4yp1crdBANMNxySuDZKcBLUObs4/QtFB7Qd4ffFJnEEPNl1j+kjptS6ikJf1z07YyA6O4BOlvaRQpXBRtUqgE1RVLf2Ve8LL9zMQrvqvJA/Dx7vAezWyAADQiq+xAedrnaa5zJJNg+dS0fINzJ7PxtomqekSFi7XbFessUbcmmSDmuhwpHEAt7qBJKeKsDzFWWZipZUo3iSLBXohu/thMnAZ24JJ1UAn9loiYls0hULL4IfSROR+gEZ3veEG6IJVNZvhfe/vXu0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR03MB5608.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(66574015)(186003)(26005)(83380400001)(2906002)(6666004)(85182001)(7416002)(8936002)(9686003)(33716001)(6506007)(6512007)(966005)(508600001)(82960400001)(6486002)(38100700002)(66556008)(86362001)(4326008)(6916009)(316002)(5660300002)(54906003)(66946007)(8676002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2w1Q2lyWStUTWVMWGZUL3RCUDhURzlHSGdKN3lhS0czTFFuTWtBMzhOcmZN?=
 =?utf-8?B?TVdSNWI2cUM2R0MyQTQ4RUdhWTV4WERMMFk0SGhsYTZqbm11RHQ4TXRPZ1VW?=
 =?utf-8?B?dG8xZENlYWNQZFZVWGtkazZvQWVPZUx4R0lmRXNINDYzTTlQOHFTb0czbTRL?=
 =?utf-8?B?L3RBcVpVTURVUmVkOXZGRHhCQTNiWGZXak9mWXU0TU51L0pXMy9JWW5jMWlM?=
 =?utf-8?B?SDNWTmdQNE5QWkpOVFh5YUI3dkRZUFhFSlBNVURub2Y5VTdBTE5SVitVWHVU?=
 =?utf-8?B?M3pOSkI0NUVkNDZZMUVNd09sS0hBVVVGeHl3ZVJLUU1KeFJ5b1VURlRjZFlU?=
 =?utf-8?B?UytJOFMrd3Fjd2NJSmNpSVYwK0N3a3NabWRtZ08wV1M0REN6b0NZODBnUndw?=
 =?utf-8?B?NEd5em9nNm5Yd0U1aGNwVmNBQWFQVmNsOU1sZDRUc1RFYmUxYTVRVWpXQm5o?=
 =?utf-8?B?dVgxcURoL3FURVdEczdoalI0VHhtTE1QbnFGRlgzTTJQV1Nlb0ZWWjFDVURS?=
 =?utf-8?B?bk9uMXpqZFkrOG45VlpjZ3I0WkFsdmluTjJlaFBhSnkwZUVGUHkxSS84UUhi?=
 =?utf-8?B?bEZMQkNlcHUyeHJwbXp0Mi9wRHpIbXlOa25TcmxnTWZFN05lLzQvNEFTbWhP?=
 =?utf-8?B?WThHdkRhaDIzMFNIaXczcjIxSXJNdlAvT2Z4Q3dhclpsNXRuZEhaMU9GNHNk?=
 =?utf-8?B?VlVTZnNNZkJ0Y2NhcVNBT2pYRHlHaWIvSUkyUlN0OTZYbDBDdHU0YmlOdVVv?=
 =?utf-8?B?NWFUOG5vYnBOK3hrWElmS24wWko3N1ZMS1NDU0dESDlrMjM5djZvd2dyUXRP?=
 =?utf-8?B?bEoyaEZFTUZEb0NKM0NUb2dQL2lSb3lyUTJIWGtkdThJL2xtNThCUFVweVZU?=
 =?utf-8?B?YW5ibWo0V0FJUTk0KzNJMzlKMDYxWEVYd2RaMjU3L3B4TTQ2UXA1ZlVUa2FR?=
 =?utf-8?B?N0VhZG5zYVhYa3BnQ0V1S2k3ZFN4YWN4QUxLRDNjZDVKVDhEQkhOdWdhT1pO?=
 =?utf-8?B?TU5wZHR3Mi9tVU9NWUl0WVp3Y0IwV1dwdE8rdjBBRjhBRVRtZmNHSi9DclY4?=
 =?utf-8?B?cDBEUlpiaXllS3FJL3JRQ1FXaU9CMWRnSE5HZVNFdVYxeWZpeDRDTW5iOFdV?=
 =?utf-8?B?NUc3TjhrckFvaWlHSkRKTjNRSkl6QjFsS2tPWC9zV2ZuV240QnFiaG4zenZK?=
 =?utf-8?B?aXhseG9kZEVjU05VYWZhOVlsSnpMUHdnYTZEL2hBYmluRnh5eU5FTjR6ZFlR?=
 =?utf-8?B?aHc4eGV3cGVyNXJveXJicGVkTEhQZDFOcVFyZi94RnUyU2dJMEduOU4xeTVL?=
 =?utf-8?B?OGlUZm82WXhBSnIvT2FQOFhLdEU0ZnFBVUZ1M3JrMHhrSmFRZ0JaR24rYThH?=
 =?utf-8?B?dFdpRmRlWEpjNEE0NTN0bklZVXlvYTZ2QlhKT2VVUzJQTkpCUGtaQzRLRW9x?=
 =?utf-8?B?WG02UFN2clRTempzRWhCbXo2NGhuUWhucDJYdmZGNndhUUgwbDhYMHBCVlM4?=
 =?utf-8?B?UWJvMzdXVkNDQ0E4Mjh4cVU0RmpGeDhXc3h2V3NSczJwT3Z5RDdiNmMrT1p6?=
 =?utf-8?B?THZpS1k4cC9jaXVQS2hZTEVoV0FhTjJaeU9jVDFORGRiSWw4Y1RnMDdPTXNr?=
 =?utf-8?B?cFFpNG5TQkU5UndXTXBsOXJua3l0cW1IZ3Z6dWpEbzdxaGRRM21wZExRY1hY?=
 =?utf-8?B?dUFTUFpGVDBhQkF1WFJ0cjBLMWV2aks1cVhNRFFrajg3MHg3TTkxbDRoc1dQ?=
 =?utf-8?B?eVFOWDJJbzBtVjVvUnJEb0RUOEtwRmZDWTZGb3JLanMwdEI2SE9hUVJwb292?=
 =?utf-8?B?WnhhbWk5QTJBWHJvelU4a2ZSbFBmM2ZVVGp4RFFPL1orQ09KQ0cxdVBKRjlN?=
 =?utf-8?B?QlZUREo0VU1DUmdobmdYaTRGVVh5ZnhIcDdkMnhRMGFlU2grWmE0b01NVXd4?=
 =?utf-8?B?L1JqeDNJcXRlcVJ3MGRNYzMycTdnT1BmYTRweU1UVitQTWtNSWc1bGFZMU13?=
 =?utf-8?B?dHIrbFltajlnSUV2c1hYM3MwRXZvcE5OUzRwUGFWWGp0eGNpbHoydW5RNENx?=
 =?utf-8?B?RjJYenpBem1mMk9QTnBlakp5aHRoK3BhWFk2RzBERlkvT2NEa1B3c2Z3VXBu?=
 =?utf-8?B?NWJTdHVQSTB2cytuWUo5RG9hc1NxQWZMZ0lISEc0UWpERGp4MUhWR1lrVjkw?=
 =?utf-8?Q?ebXgxK985FP3xbOqmdiHQFk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b16ef669-15ab-4cab-f397-08d9f5ddbe0f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR03MB5608.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 08:31:37.8054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rp+rFYbXVPx9gDBg7y3pcMUyEyBqeYP2s3PXDo7Wz9oe94nMFY15FbonB2uKPXQNhw99IcBzkZ+TyJgWmWnDUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB3777
X-OriginatorOrg: citrix.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 01:18:17AM +0100, Marek Marczykowski-Górecki wrote:
> This reverts commit 2afeec08ab5c86ae21952151f726bfe184f6b23d.
> 
> The reasoning in the commit was wrong - the code expected to setup the
> watch even if 'hotplug-status' didn't exist. In fact, it relied on the
> watch being fired the first time - to check if maybe 'hotplug-status' is
> already set to 'connected'. Not registering a watch for non-existing
> path (which is the case if hotplug script hasn't been executed yet),
> made the backend not waiting for the hotplug script to execute. This in
> turns, made the netfront think the interface is fully operational, while
> in fact it was not (the vif interface on xen-netback side might not be
> configured yet).
> 
> This was a workaround for 'hotplug-status' erroneously being removed.
> But since that is reverted now, the workaround is not necessary either.
> 
> More discussion at
> https://lore.kernel.org/xen-devel/afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org/T/#u
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
> ---
> I believe this is the same issue as discussed at
> https://lore.kernel.org/xen-devel/20220113111946.GA4133739@dingwall.me.uk/

Right - I believe we need to leave that workaround in place in libxl
in order to deal with bogus Linux netbacks?

Thanks, Roger.
