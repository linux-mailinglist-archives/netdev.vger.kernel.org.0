Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A713269AF62
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 16:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjBQPUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 10:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjBQPUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 10:20:34 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D728A64B1A;
        Fri, 17 Feb 2023 07:20:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NigKQzkMu2AOEDo/Gb0HceMM9QafaDjeP/VU0DNMgsJidJaAqHhNCfvy4nIzwVUwJt7uMDZMSlgWGbYRRz9qMRmxBFdWiEtpJEe/YKHtrblefujPKJYgEEIqFPeulCqO1EeHAgAL2jHMEwdvA+d/ewCvP+se9JejBdIjwHg/c4l3TK8RwQh92FQ/EOkrJgMELiwnh8ZXWWE7zwWa62mcE5zkwwXQN1Ze6sms/ieuusXxXoKk4wILlQURdtPrYfwtza+ecfG6OIG1nEvZo2xy7Ak0KMGXSY5wdFNvX85L/JtgTPj++Xs8BtBRPThLncNZ7xc1fSvHi7PCmjRmO0Lg5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBPBDpnyBR7eZQCjb0N9Wg9oaydqopYkoi33JxRLLyI=;
 b=NHFGzW4T4ZzwIDS7SmmHm4tWaGG9J+EhSL35TdoomxfoAJ+Zd+0WqKY1ITlvGddrhPdPV4TRCew/tgUqOovbMeFN8Jn2TOZ2wp/k0jM+igOceQDmuYfkUaiSRJrtxAHgw9UWDQ6LSQuyTUZGGE+v+/sW51RJoNd+Zajyfi1tsC3m9SiFJb3oYp/yvOCHshVNf0ZzxVABHmuxBmUle1ap+iEhhm9maD+k9SdU6Z7kKTaSW4MlEv8vEaGsZhdctCPhDTfofapiJBJ1Xi2L/FCBymfuaMGzKE5WZe1edglvj7h7cEY6VU1OcMu5zXEUelxSyaoPiwwamla9PmRHywGcIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBPBDpnyBR7eZQCjb0N9Wg9oaydqopYkoi33JxRLLyI=;
 b=BjnPpxA30xUscdnJeSs47eIkUI68ef0ZtCZrc1zGHSFn2yaQ3EaEGZf5S1cI6nILUU9ATXtjwSEKTSVETYSb3uBzqIoljRv80aC/6qwvxrR2gxn0P59ythsCmRXIChxab95Vfom7FEi5vP9lqtScE2Ros3EBjgWs6Ued7ck37y4=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by IA0PR12MB7750.namprd12.prod.outlook.com (2603:10b6:208:431::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 15:20:27 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 15:20:27 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH] sfc: fix builds without CONFIG_RTC_LIB
Thread-Topic: [PATCH] sfc: fix builds without CONFIG_RTC_LIB
Thread-Index: AQHZQrnJAHNEhfVI2kSybI2yGNc3I67TN/+AgAAJLAA=
Date:   Fri, 17 Feb 2023 15:20:27 +0000
Message-ID: <DM6PR12MB4202D1FA796BF66E6AD4C6C0C1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230217102236.48789-1-alejandro.lucero-palau@amd.com>
 <ef38e919-f7ea-0b11-f5d5-2eb4fb665c72@intel.com>
In-Reply-To: <ef38e919-f7ea-0b11-f5d5-2eb4fb665c72@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4579.namprd12.prod.outlook.com
 (15.20.6086.011)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|IA0PR12MB7750:EE_
x-ms-office365-filtering-correlation-id: 4d1d4dd4-0f49-498b-5210-08db10fa7fb2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dzfGbFjXzr7cBl6uZS07vLztPj/D2fu3q2Xz+oXoseMfY4lfBJZz/bUmEL/SlbUhWbdmfB2zGN0LpAcTwwmUQg19dXGAe4gQrtkTInsMVQgf19XhvOloc62cICMNUxavsdJw0d78ICpkE3zBeFlHHtSSpAOhzv+7V6Hl5lcqlDiV6aQnuqV+i8AxKgxwSbG9CPT10TlTCMn3OTYGrgMT0J+s5dq2NRUg8C6/GvyuRidg9QLwclY010MEyWLkDnObXiui7UGSmQIFpiBiIOhXr77lwrul/3TtjqaTwdfjnjwl/sKSyftfdeW2u+w+W+JnRgF6HslOAPhCNgQ1TEmwIGMpPsUJZTQ4cjJkM588IfuvIpYQsh6sQa7YHC5ij4XyuHafUBzMeIpZRc+oc0Xv8tqjEsCdr2JpHxKvKOVKksc7JgTwP3JgLpS8K89d83vXVTL86a6wO+JxemHoZ8pin2Suf6SJ0SBKEYDRFaVjzZIvZqhp2NTZdxKA0M0bF3LMcJuIYO67y1R2xP+z2+kMN0YBa+j+4sxG1cdqYy5Rlds0Jxeuanf8DiOZDl8Jp2nonl7i7iI+9DmRQei/9vnye8Q3DoVxENkgH7TQChxYWQkKbbPxrrdjLc/84Jz3u2p7li8Lm7TnWJmfr1KxoSrjhrfxy/oanuFMJO+DaFT3e+rbEIfxitih58dgZym0bK2Uaj5M9Tf2OIA7XnJIGMLFAf0OCqdWUEfcoFqr2O0eN2eptW+1+opclVu2N+RkvJ5C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199018)(110136005)(33656002)(83380400001)(52536014)(8936002)(55016003)(4326008)(38070700005)(41300700001)(7416002)(5660300002)(8676002)(6636002)(54906003)(66476007)(316002)(122000001)(66946007)(66556008)(76116006)(64756008)(66446008)(38100700002)(26005)(186003)(9686003)(6506007)(7696005)(71200400001)(53546011)(478600001)(966005)(2906002)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXlRUkxELzhhWG5RbHBjRFNCZnE4ckF5eE4xdkE4anVZQ3BFK1VKVXNyZnRM?=
 =?utf-8?B?a01ROFovN1ZvLzAzbklBMHVQWktzWUtYQ2dPNkJlRkt0aXFKcHhtSDNSQkxi?=
 =?utf-8?B?MUR0eEZUMklMV0o2b3cyMzlxS24vOWFObUxiSlZLOUhTMk1SY1NJRDE3NXhJ?=
 =?utf-8?B?TU81M3lyZ3JOWERtUVVXRHlub2lrRk9MZ3kwdHlscGljMHluV1hSenpQYTNQ?=
 =?utf-8?B?YURrMExTNHBaYmQ5eFd4UXdYQys2VXRPQkh5OWNUTXZUR2F5anFTcm9wTUdu?=
 =?utf-8?B?ODRZV1NOWVZDTDFiZHpiVEx6RjhmdXBoMm5wdnZDUGphTU1YOGhnRmxGeEdi?=
 =?utf-8?B?QmtBYkpmQW0vSlluSnFvVXlyMGZVempmZkRZOXZVck9oSTFnbk9rZUxWeFEy?=
 =?utf-8?B?YmhZT1pNTHp6T1MzUko5M1NGZDJuckpIdlZzbFIwaitJeHFUTmUxNDNWZ2Fu?=
 =?utf-8?B?MEgxUGJRYVNpRHJIZzJGN21Sd1QzR2ZVWW5nbEVhSXlNOHovQ0grYWFWWGNk?=
 =?utf-8?B?czh6TFBGWmJnTEFtTTcraUR6dnc4NTZNaTZEVHEyZWhzQ0psSjgyMEtnRk1H?=
 =?utf-8?B?NjJ1b1NUKzducXcyOFVuY3diTmJpdXFNejdlUnM0dmRoK05xNWhZbjQvTmt5?=
 =?utf-8?B?RmpKcHJnV1NTbVZtSnRySE1XUHRhVW0zUjZseExudDhkQW9kWk1lS3lTRHFy?=
 =?utf-8?B?RXlKQUNqdi9oSXliOGxmV0FwUS94SVFkcmR5YUdkSEtxRFJJWU5yRGVqMVVl?=
 =?utf-8?B?UW1yYndHMm93M25YV1pWeXphRGh6eW92S0lna2RTd3VOaE13NTJMbTZOekFh?=
 =?utf-8?B?LzAyV3p1SENkY2lKQkpHYzR4RktrSVVRR05NTU5Pci8rR0xiRDV6SzZNYkU1?=
 =?utf-8?B?Ujk2ci9ZcG5TMGExWXZaR2ZWRFFUNjNpZHFUb3dqdzRoSHl5YURpYlhnLzFU?=
 =?utf-8?B?WlNPelZrNDlMb2VkS2FzUXVITVRPQUl5QkxNS0pVSTc5S3piVW91em5YT211?=
 =?utf-8?B?WHFuMnNQdVJsdEk0WmRtZ0k5b0tFWkNjSjRjTXRWU1A2UXovZ0hFcmZIcGsv?=
 =?utf-8?B?ZDhoNi91QmU3Ukc3QzlkTmlhNHFvZGM4M1VwMlBOVmFWR1VKYUxnTng1a1VS?=
 =?utf-8?B?bnhwNVZEcWFISUZxUTFyVERqVHJhRmdOOVlUMWErQW1HS0x1YkU4Z2pvRDRP?=
 =?utf-8?B?NERVNytxcHl0cW8rSGozMDhYUFppeGVQdEVScU9sdHlFeGxLZFA5RHVHWHNK?=
 =?utf-8?B?NndLV0lSQTZIQ2FEUE1UL0RtUjlHTW9MblFxV0RTTWptV0xYeldjRlpKcGgw?=
 =?utf-8?B?UjRYQzB6dW9DT0FwL0c2a3piSlE4WER1MlV3djNIS3d3bHNrclcwRkZRS0hE?=
 =?utf-8?B?OWJFUmdpNWdhQ0dENmtuSVNHYkdLTFJOeU5wYi9ydUtPQnFWZGd2bHNMYmV4?=
 =?utf-8?B?MTVWSlpyYU5SMlNMRHNhREtiZ0RVeFNaK2duMVhSTHIzSjYzUnl4a1VNNUFK?=
 =?utf-8?B?VGRTN1lSTWhodTNPcVQzcUFsenU2YW85eUVhUEgrQlVmTlNyWFlieWFhWXNM?=
 =?utf-8?B?ZHozOXcwaEtSdXYzTXRoYWhQQVFyODhoVFRrYU8vbnNsdTNJKzRTZnZwZnBP?=
 =?utf-8?B?MUhSTUhGbUVzWlE2SUlvZVVjb1lFNVV0WlNKaHBMQnUvMHB2NzJIMUNMb21v?=
 =?utf-8?B?bVlZM2s3bExzd08rSWtDa3lKbEVvS0M1Wmd2YzR3ajVEUXVBdExDUXc3UzZO?=
 =?utf-8?B?YlhFV1l5NllsWHBKdjFaNm5HakFaZEVqaHlnZFozTnVOWE1XU3RDbUZOMHpi?=
 =?utf-8?B?bVRBNDdKRGNWdlJXMU1DanIwOVBaNWdhVndRZS9HQXpDdmFCeVN2SDBvWDBP?=
 =?utf-8?B?SVNiNkpyK24yNDZBQXlpaTRqc1loY0pJemp5OXlFNkVaai9DS1VxN0RUWXRN?=
 =?utf-8?B?RU5HMHZLRzd6QnVaTHhTZ1Y5akNyMExnUDVHSlVPYzNQYVZ0UEoraVFIOXRn?=
 =?utf-8?B?Q280SXQxT2VwOWZ1d0JyQmRLWFlaU3oyRG1zZm5hUFhGVnNrMjJCZDRXOVoz?=
 =?utf-8?B?VEhhcHZicFg0cDRML3JnZGd0NC9WTnc1U3BNbmJtOUp1WTgzN0tVeFptais4?=
 =?utf-8?Q?mFoQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58B03DA6624A044B99B00C581E2DEB8D@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1d4dd4-0f49-498b-5210-08db10fa7fb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 15:20:27.2849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ay++68o5Wb1l+gkRWW6K+1IPI51fLVQWiihZpdC4hW9m7001sgT9nog2eBJFzY+XBskY1yq4gipZY1BkxnPgpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7750
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzE3LzIzIDE0OjQ3LCBBbGV4YW5kZXIgTG9iYWtpbiB3cm90ZToNCj4gRnJvbTogTHVj
ZXJvIFBhbGF1LCBBbGVqYW5kcm8gPGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNvbT4NCj4g
RGF0ZTogRnJpLCAxNyBGZWIgMjAyMyAxMDoyMjozNiArMDAwMA0KPg0KPj4gRnJvbTogQWxlamFu
ZHJvIEx1Y2VybyA8YWxlamFuZHJvLmx1Y2Vyby1wYWxhdUBhbWQuY29tPg0KPj4NCj4+IEFkZGlu
ZyBhbiBlbWJhcnJhc2luZyBtaXNzaW5nIHNlbWljb2xvbiBwcmVjbHVkaW5nIGtlcm5lbCBidWls
ZGluZw0KPiA6RA0KPg0KPiAnRW1iYXJyYXNzaW5nJyB0aG8sIHdpdGggdHdvICdzJy4gQW5kIEkg
Z3Vlc3MgImVtYmFycmFzc2luZ2x5IG1pc3NlZCIsDQo+IHNpbmNlIGEgc2VtaWNvbG9uIGl0c2Vs
ZiBjYW4ndCBiZSAiZW1iYXJyYXNzaW5nIiBJIGJlbGlldmU/IDpEDQoNClRoaXMgaXMgZ29pbmcg
d29yc2UgLi4uIDpEDQoNCkknbGwgY2hhbmdlIGl0Lg0KDQo+ICsgImFkZCIsIG5vdCAiYWRkaW5n
Ig0KPiArICJwcmVjbHVkaW5nIj8gWW91IG1lYW4gImJyZWFraW5nIj8NCg0KUHJlY2x1ZGU6ICJw
cmV2ZW50IGZyb20gaGFwcGVuaW5nOyBtYWtlIGltcG9zc2libGUuIg0KDQpCdXQgSSBjYW4gdXNl
IGJyZWFraW5nIGluc3RlYWQuDQoNClRoYW5rcyENCg0KPj4gaW4gaWE2NCBjb25maWdzLg0KPj4N
Cj4+IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4NCj4+IExp
bms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL29lLWtidWlsZC1hbGwvMjAyMzAyMTcwMDQ3LkVq
Q1BpenUzLWxrcEBpbnRlbC5jb20vDQo+PiBGaXhlczogMTQ3NDNkZGQyNDk1ICgic2ZjOiBhZGQg
ZGV2bGluayBpbmZvIHN1cHBvcnQgZm9yIGVmMTAwIikNCj4+IFNpZ25lZC1vZmYtYnk6IEFsZWph
bmRybyBMdWNlcm8gPGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNvbT4NCj4+IC0tLQ0KPj4g
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYyB8IDIgKy0NCj4+ICAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2bGluay5jIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc2ZjL2VmeF9kZXZsaW5rLmMNCj4+IGluZGV4IGQyZWI2NzEyYmEzNS4uM2Vi
MzU1ZmQ0MjgyIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmeF9k
ZXZsaW5rLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2bGluay5j
DQo+PiBAQCAtMzIzLDcgKzMyMyw3IEBAIHN0YXRpYyB2b2lkIGVmeF9kZXZsaW5rX2luZm9fcnVu
bmluZ192MihzdHJ1Y3QgZWZ4X25pYyAqZWZ4LA0KPj4gICAJCQkJICAgIEdFVF9WRVJTSU9OX1Yy
X09VVF9TVUNGV19CVUlMRF9EQVRFKTsNCj4+ICAgCQlydGNfdGltZTY0X3RvX3RtKHRzdGFtcCwg
JmJ1aWxkX2RhdGUpOw0KPj4gICAjZWxzZQ0KPj4gLQkJbWVtc2V0KCZidWlsZF9kYXRlLCAwLCBz
aXplb2YoYnVpbGRfZGF0ZSkNCj4+ICsJCW1lbXNldCgmYnVpbGRfZGF0ZSwgMCwgc2l6ZW9mKGJ1
aWxkX2RhdGUpOw0KPj4gICAjZW5kaWYNCj4+ICAgCQlidWlsZF9pZCA9IE1DRElfRFdPUkQob3V0
YnVmLCBHRVRfVkVSU0lPTl9WMl9PVVRfU1VDRldfQ0hJUF9JRCk7DQo+PiAgIA0KPiBUaGFua3Ms
DQo+IE9sZWsNCg==
