Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F317A66145D
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 10:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjAHJqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 04:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjAHJq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 04:46:29 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF11183B3
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 01:46:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bqW+nXEnrWzAK2BlFeI2TnxOHbC+q6TebfJ/WRrMXzeswYdINXOmGTNFSIsSX+oaj2duXXt6f6lk2Sg3gNoP0tkhdIW9pyP+kgV8ZdR3qhd32p5y/fxkkx9tOGkoJFh9HnDPXoDuv3nCsYwuqi54oRY2tZPfPbVzdgOxaJesMvMt2CF5pzuR9YGbNpvuHKs3IgDMpW6GvVbJRpsE67rEDqq4gteyG8crsW2RePfXrYHjCvWtw+nYbERR3CXFpSDCo1ezi+so87im1ikyZXIXr8wZwWVi4CY0Ppv14i3EfwCmNggnlQVPRvhaXjIyPunKS6KUjB48+3nuNbJcQjATvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fLHZ1lG9XvghLyOcbldbCvfjzLqNzd6qzVZHfg02A5w=;
 b=UyfmydoWHEkjm7UgkDE/xYWARTj4xmVxMzQ2oOnOWCQ6Z1DxEmZK3JG7WFJFjWkQBl3Fzm2Z9tVlguWUv+slSubQyTzR5ejPeAoW5aZIjQoCcfafwrb8D6x0ITQddLsfIRL9vM3Tdp4TGbTwk/CSacijF4jRXcMKhMPcCIcHVjYhWxAjecH7Xio0NPL5rpvYcIZD3dDOTvRi1XxUykk2ts5uGod+6456sjmNLJH6XuWXw+OZ/HuIB7yYtkea9jXbr6bnsUiWtFwAclVqmWn1SbR2OwN8gq3pXc4owKdAhNvCleN1QjRpEo3MyUDaUT4Qq5tyHMtWZouxEZwWvm8IvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLHZ1lG9XvghLyOcbldbCvfjzLqNzd6qzVZHfg02A5w=;
 b=cHan/sOyArRu77a8WQQVCSDeVLl4WDGihUjOgqn493jQUTZJJu2lGcloWn1jzDxuiVDc0DhZcp4+J81uLzOXL1NI0jVrTWavv7Ellq4XssRxKSvQ9IPoRQ5p4CL9+C1RrvEAXU8u3Sd5ab01uQKz86itsla/SUoxr5Z5dfPbirbWcrldddJ7KyXIvONIDGurbC4wCiWapYqD1RfNzhw6A6pFLgIuavPjW13WNLNteA0bRg4pYF9Lzqd2dSOI2zmEDovSZ4vkSChKdlCWQPWklCmaNN1T3g1ToJFZY4G1JLOw7EU4mz8BxbAbvE1cc2tbMLEdbH/sFd5y0KrnKwsSWQ==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by MW4PR12MB7357.namprd12.prod.outlook.com (2603:10b6:303:219::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sun, 8 Jan
 2023 09:46:26 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e%7]) with mapi id 15.20.5986.018; Sun, 8 Jan 2023
 09:46:26 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [PATCH net-next v6 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Topic: [PATCH net-next v6 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Index: AQHZIdPaFaMiBfrX7kOK449UwGF6U66TlSsAgACzD1A=
Date:   Sun, 8 Jan 2023 09:46:26 +0000
Message-ID: <IA1PR12MB6353B1E92F98FEC8B1B04F8EABF99@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230106133551.31940-1-ehakim@nvidia.com>
 <20230106133551.31940-2-ehakim@nvidia.com> <Y7n6hF3voEe8Hv+5@hog>
In-Reply-To: <Y7n6hF3voEe8Hv+5@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|MW4PR12MB7357:EE_
x-ms-office365-filtering-correlation-id: 53d63961-f5ed-4573-3197-08daf15d3610
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Y3LQO4bRrifgekY8r2YWez+BGhjwfIRhsjUnuvKS9wnjVn86WuqAjvswK3jyIgo4fdu8SbaFsX4pIr6TqueUwqsRxoiTg7wPj20hM5z0UTNj7psJN6u81xgQwy74FD/PS/3uI6L+GMmE3iipMl+Qazp5ha+oY3SDexf6dBDjENOu4xC1wyOaYvw7sNq3AF7jHyH632zRBOkSoU8CVNLtG/wmb+ugeRtoEqCfNJXA21g9wizm76AW4AgQ8w8FSJXtgqlmLrMlje6sNqJPstCEdw3sUh0L6QOqpklEtzRtewAgvEnJC5d67kq6MLVvGCHcePXJLWOHKiCwOZjbcGaPacAoExXpZng2RtkLTQgdBiZ6H30Xqz05jaNNUV1aJ/o6zG6Rkrm2g3Eu8B+zzZo/F4leFR3XCT7WsecaBxIlb40LdVWGgKP0xNfGt04i7EuY9gnU/WptkcTxkwwlm7AFD3x5+Mj2Fj/bySkoeocXBj8Bk1jwY0jDms1dNR40M3iynrhdwn3k8XD6/poBbdzQstaMFPnOcxMIm9s5lLlVy8fYKGkN5U0BKl7UaCTf9YGFOqJv9k+SaGwLSoSSTFDxodyI+0uos522MNLs/PfAkv97W8eTgMjEcPB8aCvAmBfe/IZDIUo5aRNL5h1uaVUqNFVTAR3gn3IwV16kWWCcTaJXcyp4JnnqgeAYFlxQvK4GQhr2D9cwEQ858rO3Zdp2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(451199015)(33656002)(5660300002)(316002)(71200400001)(7696005)(186003)(26005)(9686003)(478600001)(38070700005)(41300700001)(76116006)(66556008)(66476007)(54906003)(4326008)(66946007)(64756008)(66446008)(6916009)(8676002)(83380400001)(8936002)(52536014)(86362001)(55016003)(53546011)(6506007)(122000001)(38100700002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3ZydXdnbmY3Q0JGZEU0SmxRM2ZONTZ5Z1pIZVFPMklsSmplVTlyMVlzVkNi?=
 =?utf-8?B?cVpHalcrdStGUGlEVlFwQzRiTXNwU0RUazNaeU1vcnRlSFdQSnlyVTFCcXRw?=
 =?utf-8?B?R042Q2VKL3VTb3pBdUh5ek9yVHl5WlRWTTdDVVZXZWFzdjlPT0dxVzFaWVFY?=
 =?utf-8?B?STcrT2FTeVlpaXh4bVMwV2dISDdMVFlvR0YvYVRNWGM2bklqSWEzRi90cGUr?=
 =?utf-8?B?MkZhL0hhcHQrOVZvTVVFNVVaNjIxN3VoQmwwRUM5RExVL3R2OURUeGlrL0VQ?=
 =?utf-8?B?YXJUUWMySmorR1I2bEIwNDNTZjlkQVdqb3lUTFNPZnBGNTYrK1phSXZ0VnNv?=
 =?utf-8?B?M1hIU1hJZHlmc1d2OVZIdTk1bmhwZEVUOSt2OTJIRXVOWW4wS05nWml6Tllu?=
 =?utf-8?B?YXBBeG5QNm9VNzF0SnBQdk1xRVFxTGlDR01oa2ZVMzNabVJTcmZQWUx0NFVB?=
 =?utf-8?B?d0dka3orU2Fzc1JIUUhSSjdjN21IUEZGRTRvczNDUFZabytKL0RZUjQwdWF5?=
 =?utf-8?B?VEVYdmpleTJyTnNzSlA2REIyeWV6Z3AvU0FLaUEvRTYxa24wV00xbGcxS1Fr?=
 =?utf-8?B?YWtpcXc4UlZHTXZ4TStYM3ZjY3dONmk4c1Q0SEpBTmZRZktaWnlLYjJZNkgx?=
 =?utf-8?B?RXFOQUs5allBVThtdENIZHh5YTIvTnhjaDJpTVpiaENtRFV0R0xRRkt1MCt2?=
 =?utf-8?B?SzhkZjU4djByK1dIQ3RhaDlLaHRwU05mNzB1b3lTWnljSUduVWRhajNmY1VP?=
 =?utf-8?B?OVpBa0pMdDlpUXUzK1I2bWZlck5qMTFmb3dkNENMZjdLeTV5dU1YZjhoRDVt?=
 =?utf-8?B?YzhNTGIvMXdQT0JLMHdqQVloajZwSytlLzFvUVdvNnBiNysrOWlHNTNZbVJ6?=
 =?utf-8?B?Szd6Z3lRbk5vSHluLzZQTStxRklhbVpqRlZXak43RDBHVHlSOWNmM1l3UUEx?=
 =?utf-8?B?Vmx4bytEeXdvaHFuNzd2RjNNenVVOGxyN20vVG1UWGxsaWJVYXZGbVY1ODFl?=
 =?utf-8?B?SHJxbDJ6OGtoVURQMktRODdpeitCVjUvSWhKT1paUEJmaENFSU5tY2RjdUht?=
 =?utf-8?B?RHc5TUZrMjVXOEdaeCtCNkRZL0E1b1dNQkpnRkNJSVE4N2JLajExL1lra1dk?=
 =?utf-8?B?dnl0MkdCL2M2NFNLbmxIZmh4TGNnckJ6UFVSY1dUYWZ1NXdCbnhqMVNmSGRs?=
 =?utf-8?B?bVJoU21QRVJtWWhnTkt1ckhSeGFSM0RCV0J4eUllUk1YNXNFUlJHUDF2WXZM?=
 =?utf-8?B?dDlodE1wNlZEMnhLdFZVSFZRY0NDc0ZDM3JVTEhlKzF1dXVIcHVQc0ZhOFJX?=
 =?utf-8?B?UjFXa093RXFWOE1QYjdZZjBiYVhpNlE5TTFqOGVzS0xYQVdJZ3FlK1Azd2VM?=
 =?utf-8?B?bnUybERKZ0hjY2RUNUtzVmF0TzRRTW5LNnNMOWd4cnFwdlhNVWhDWmYrTWhH?=
 =?utf-8?B?SzMreERaYytENml0UjVzeXQyc2xORXB5aXArc3N0SjJlQkxYYms4dm9OeVFJ?=
 =?utf-8?B?bTl2ck9WWjM2eGxhZ2hTN0Z2MElMQ0NSY2h1QWNEc245UDAwaDMxdHBOVWtS?=
 =?utf-8?B?bEJVTUVzMXdoL2hoY3piaE9XS3ZzQnk4cXorZlNlN1l4QVo0SVdkcllDcEIy?=
 =?utf-8?B?OE5uTmpubTg1N0t2ZGlEZ1pZRDZEQ0ZFVi85dGsySEVtdkRtSXNCUmw4YWQ5?=
 =?utf-8?B?Y3IvL1JUc1FRMkFEQzNvZkFhOVdEczJYNTZrTFlxQ2VPOE0yM0wzVlZWMU8y?=
 =?utf-8?B?MHZEVndhNmVDdWFZdmhSNllTYlNuazFZUy8weDBMQTV4ckMzZWZ1Q0dBMjRw?=
 =?utf-8?B?aVRNR3hpdFZtZ3lJbjlGNTM4OHQ4UkI0TCt4dWk0SmVNaE9tMWxSbFdSMDBE?=
 =?utf-8?B?Qzk1UHEwTEcvNVVNdE0vMU5HTVV6V0lOTnVUV1QxdER5NjFxbHdOUm9GYzBz?=
 =?utf-8?B?K3dNdDBJSXA0K25xZVJvT3pweWFUNm1RNzJzemE4WDF6cytLL1N0M0wvSmFX?=
 =?utf-8?B?L3ltbFZEYUtabDlTMll5QlBmdmRJZHNBTjZBQlBHcTRTSEtxcitHZVNPcStk?=
 =?utf-8?B?bDd2MjRWMGJmcXVGT28xR2pyZEhLc2Q4WldJSHJTWkVKZkJHblFtcWFiM1JC?=
 =?utf-8?Q?HEJg0v1B91TxKu4JRimwDpLw0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53d63961-f5ed-4573-3197-08daf15d3610
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2023 09:46:26.7041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N3b7I/nrq+67SBox7/s+yL61WPHtIyiOVRemca02nbF4dDui04Dayl5KCSBFZFzxFxSKhT8wstb8cRZHDzp+iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7357
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFN1bmRheSwgOCBKYW51YXJ5IDIwMjMgMTow
NQ0KPiBUbzogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiBDYzogbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgUmFlZCBTYWxlbSA8cmFlZHNAbnZpZGlhLmNvbT47DQo+IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsNCj4gcGFi
ZW5pQHJlZGhhdC5jb207IGF0ZW5hcnRAa2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IG5ldC1uZXh0IHY2IDEvMl0gbWFjc2VjOiBhZGQgc3VwcG9ydCBmb3INCj4gSUZMQV9NQUNTRUNf
T0ZGTE9BRCBpbiBtYWNzZWNfY2hhbmdlbGluaw0KPiANCj4gRXh0ZXJuYWwgZW1haWw6IFVzZSBj
YXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiAyMDIzLTAxLTA2
LCAxNTozNTo1MCArMDIwMCwgZWhha2ltQG52aWRpYS5jb20gd3JvdGU6DQo+IFsuLi5dDQo+ID4g
K3N0YXRpYyBpbnQgbWFjc2VjX3VwZF9vZmZsb2FkKHN0cnVjdCBza19idWZmICpza2IsIHN0cnVj
dCBnZW5sX2luZm8NCj4gPiArKmluZm8pIHsNCj4gPiArICAgICBzdHJ1Y3QgbmxhdHRyICp0Yl9v
ZmZsb2FkW01BQ1NFQ19PRkZMT0FEX0FUVFJfTUFYICsgMV07DQo+ID4gKyAgICAgc3RydWN0IG5s
YXR0ciAqKmF0dHJzID0gaW5mby0+YXR0cnM7DQo+ID4gKyAgICAgZW51bSBtYWNzZWNfb2ZmbG9h
ZCBvZmZsb2FkOw0KPiA+ICsgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpkZXY7DQo+ID4gKyAgICAg
aW50IHJldDsNCj4gPiArDQo+ID4gKyAgICAgaWYgKCFhdHRyc1tNQUNTRUNfQVRUUl9JRklOREVY
XSkNCj4gPiArICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiArICAgICBp
ZiAoIWF0dHJzW01BQ1NFQ19BVFRSX09GRkxPQURdKQ0KPiA+ICsgICAgICAgICAgICAgcmV0dXJu
IC1FSU5WQUw7DQo+ID4gKw0KPiA+ICsgICAgIGlmIChubGFfcGFyc2VfbmVzdGVkX2RlcHJlY2F0
ZWQodGJfb2ZmbG9hZCwgTUFDU0VDX09GRkxPQURfQVRUUl9NQVgsDQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBhdHRyc1tNQUNTRUNfQVRUUl9PRkZMT0FEXSwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG1hY3NlY19nZW5sX29mZmxv
YWRfcG9saWN5LCBOVUxMKSkNCj4gPiArICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPiA+
ICsNCj4gPiArICAgICBkZXYgPSBnZXRfZGV2X2Zyb21fbmwoZ2VubF9pbmZvX25ldChpbmZvKSwg
YXR0cnMpOw0KPiA+ICsgICAgIGlmIChJU19FUlIoZGV2KSkNCj4gPiArICAgICAgICAgICAgIHJl
dHVybiBQVFJfRVJSKGRldik7DQo+ID4gKw0KPiA+ICsgICAgIGlmICghdGJfb2ZmbG9hZFtNQUNT
RUNfT0ZGTE9BRF9BVFRSX1RZUEVdKQ0KPiA+ICsgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7
DQo+ID4gKw0KPiA+ICsgICAgIG9mZmxvYWQgPSBubGFfZ2V0X3U4KHRiX29mZmxvYWRbTUFDU0VD
X09GRkxPQURfQVRUUl9UWVBFXSk7DQo+ID4gKw0KPiA+ICsgICAgIHJ0bmxfbG9jaygpOw0KPiAN
Cj4gV2h5IGFyZSB5b3UgcHV0dGluZyBydG5sX2xvY2soKSBiYWNrIGRvd24gaGVyZT8gWW91IGp1
c3QgbW92ZWQgaXQgYWJvdmUNCj4gZ2V0X2Rldl9mcm9tX25sIHdpdGggY29tbWl0IGYzYjRhMDBm
MGY2MiAoIm5ldDogbWFjc2VjOiBmaXggbmV0IGRldmljZSBhY2Nlc3MNCj4gcHJpb3IgdG8gaG9s
ZGluZyBhIGxvY2siKSwgbm93IHlvdSdyZSBwcmV0dHkgbXVjaCByZXZlcnRpbmcgdGhhdCBmaXgu
DQoNCkFjayB3aWxsIGZpeC4NCg0KPiA+ICsNCj4gPiArICAgICByZXQgPSBtYWNzZWNfdXBkYXRl
X29mZmxvYWQoZGV2LCBvZmZsb2FkKTsNCj4gPg0KPiA+IC1yb2xsYmFjazoNCj4gPiAtICAgICBt
YWNzZWMtPm9mZmxvYWQgPSBwcmV2X29mZmxvYWQ7DQo+ID4gLW91dDoNCj4gPiAgICAgICBydG5s
X3VubG9jaygpOw0KPiA+ICsNCj4gPiAgICAgICByZXR1cm4gcmV0Ow0KPiA+ICB9DQo+ID4NCj4g
DQo+IC0tDQo+IFNhYnJpbmENCg0K
