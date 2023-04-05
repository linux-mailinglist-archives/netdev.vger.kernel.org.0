Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395AB6D78AE
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237510AbjDEJoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237457AbjDEJoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:44:02 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B545278
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:44:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6iDVBLdzz4nTzVxmC/LjKZf9Kc5CDKLP9u0oZy+34fhR7Oq5wPQ+lldVrcCW4/D1n5PCuLSHmbaXt9xGkvv2b46m7WnbqnbxfBUS3Bl/4Iy2/bpmS0lg4uywj/wwBRreSv544JLOMDgjbcUpfAyI4tjvbGYM4l77MFi7jA1w4ua7H74Kz/5jetmFyzTiTPdEeL0kovTH3HnzlTWdKjKeihYFuZ0qZ6/11MG5UgUmJ9/Di95AL07KVCaJl540vsPj1eMy5d9MiHa1LsO7Kla8JeHM6ZnmN9L+/4eX3hDZDoVg1izc+keUsN450lgFW6CqSvXmjVMUVD365HHh2C4cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f85WDOwhibfW52siBX4+iASz0jvkPv2fB0tDWK5jOdo=;
 b=LXRD6+BPHLZmNWbjTQYUHr/d258yFgR5zEODJmYcMosxaPjD3XGwFgsh6Qcyx+AFdMWm0gr3k6VIrbAJE8ySnhxRVqVuujlK6PdnPP73mm2yJigaf+FZ64hYWi6cT3/C6JW0jmBJWqiY4FHWBLmSbye2oa+OH3AJmuzObEaXnx05TfWw4JdE6ZXeAIwyGNdvihGEsFKERqh/DtT3usc9t/oo5kjsiZxu50BWXqdPaLMedJWqSZlYhYIHEN9LmtVl2bvTL5al3mZ5SQf+kHxdmm/zdAzu8wi5bxtX89K/oG9JEmgNdl+MXFIyoZ9+9sZ5cURleSM8IbN0R1cBYzxSzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f85WDOwhibfW52siBX4+iASz0jvkPv2fB0tDWK5jOdo=;
 b=IviAQI+2aHtb6KMvuBsoHm8EC9EHX3P7qWWWEfSqr0q5SGzvh+WtbwW8D0s3u7E2slqxwStZfm8sGgWvPdAyr1kKRp4C+eHzftbUoH8cX4W573fB0rlBMMRFGP9aBM35YCeIGFlZ+Jshz7veavXGymDIP6tiAEwysVxtqJ8kYs8hq5aw/sWuU5qjVYQpoL4YkqMsDtsGAtlK0N+p+gnKljET+liruS8H1JZHx1WN/bRs4419Vei9dow9WT24Gc4sl+8c7ppJ9HPsfJwhUWUYtly9rl1qi4meUMnd7jFdJczFKN6xRbiJX2EJuDPznFZvKAf8Fj40oOP6xrmo1xELlQ==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by DS0PR12MB7630.namprd12.prod.outlook.com (2603:10b6:8:11d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Wed, 5 Apr
 2023 09:43:59 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 09:43:59 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH net-next v3 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Thread-Topic: [PATCH net-next v3 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Thread-Index: AQHZYw+ZSOct7ANcI0GlSxVyrQ3ZXa8cfnEAgAABZNA=
Date:   Wed, 5 Apr 2023 09:43:59 +0000
Message-ID: <IA1PR12MB6353A4A48F6FA24C6886C71BAB909@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230330135715.23652-1-ehakim@nvidia.com>
 <20230330135715.23652-2-ehakim@nvidia.com> <ZC1BbKhzYTjGQuzz@hog>
In-Reply-To: <ZC1BbKhzYTjGQuzz@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|DS0PR12MB7630:EE_
x-ms-office365-filtering-correlation-id: 9bf33090-7d11-47d7-c874-08db35ba4845
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NOOCYnznXPMNjsKLVB1ytUN8xgedBqPJgTJ9vfnNxeWRjU2uUXJv4M9hXwxEY07vIdJygg8ip4njYSIb8wznhFECdEoVvmXMSAQO/7xU4J6k4b8VKB1jXQ+NdSBscG6Fqx+IaF8K4IHKoxUy3iT7Z7CUS1pL+lVqnMiEYFZSOuf+HToSY3TM8FrE8yx35hhwjwW2XyrjW2kieGijr8lOAgW39vnvzfbACWlJFUAaOFyaESPg9BeWXjAsJaaUjiaRpcgcAB6zqTNqBnG6fgu5SD2GnJLeyCTLvCUxg6xKPFqikYcvcomYDq/HN9yVvHEDxg5Ys9rHpm+y9F9xo1lXvm2EW80D87Q1hCIMfxPOJ6jSVToht4sXQo5W8RTX/PERT01mw0iIFxlhugjND3sgCUobLf1QxlVzTk/Ni99fBj2HBDKEFe8KuSztQ3xnn2/ixgA3F1hgTF73A9kuNT3FXNMaOGtMBrVrOBVL5k/KmctzFQlOXkgpjo9tG1GHmfSiAUhFNrKlvQgVdQxicnZxcKPcxkcH6kSFLOY3h+M69AqHrXpdV8s13RNhc9YJ0HzaNfNSrWv3/3E9fz+ubEGwy7N7lMShlgJlkSHHnRViUtaoijzF00wwx5DyMqwzCnNv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199021)(71200400001)(55016003)(6506007)(122000001)(66446008)(66946007)(5660300002)(64756008)(66476007)(6916009)(478600001)(76116006)(66556008)(316002)(8936002)(4326008)(52536014)(54906003)(38100700002)(8676002)(41300700001)(186003)(83380400001)(9686003)(26005)(53546011)(7696005)(38070700005)(33656002)(2906002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUFlUG1XV0VYR0lzUDhURUE2bFZENzc5eE5uTWxOQ093bVJwSjdqUFIzODE0?=
 =?utf-8?B?Zkw5RDZjd0Z6eUNxVG00dlBhOVk3UnVKSUdiN0Q3M0tCNEZmcGJhdDV1ZmpK?=
 =?utf-8?B?ZkFKOHFXVHpRK3VCR2pFa3prckdkOE1YclJDTTAvWXloYTM1UWxsTFZWdk04?=
 =?utf-8?B?L3BYV3FrSzU0YVlBNU5JeGRnQmZyWXEySVRpaHdkK1JFQlF1MzZYdXZHZi92?=
 =?utf-8?B?V29xc1lkYVdwNzJtRFVDUmhHQitUYzE0ZzhVV05nd2JxRlRBclRiMmYrR0Ri?=
 =?utf-8?B?eGhTa3lrQlFXRUtvNC8zYTFOd09wdEloVXdKdDkyT1BDcG5EUlAwSmw5U3dH?=
 =?utf-8?B?d0pMbitrTXo1ZTlQbUFrZkJ2d05leGpzdzVnd3AySW9JVjNTb3J2VmY2OC9p?=
 =?utf-8?B?Y09XVk1NTVdNTzMrKytyMmhEYXpTTzVCTlE3blRhM2pxNUZsUE9PSm0rOVgw?=
 =?utf-8?B?R0syYjJWRTdwTE9vbnR6cGRNS0VZbXZwais2dEJIcjNKNkl6TW12cElGSXZ6?=
 =?utf-8?B?Uys1OE1JeGpjUUV3TVBYQUNnYUpmOXNDTmE5bzBvK3Y4WWRtVmdkM29tb3VD?=
 =?utf-8?B?d2FibE1KTW81a1JwekF2bGJNL21nSXJ2WkxZemp5bWR3dnZuQzZSTUlHcmdl?=
 =?utf-8?B?bzdmeDdmN3JabVVGOUduQVNQYmwxeU9iMDhFbW1vUkhpamtKT09RRGR4WmU3?=
 =?utf-8?B?NUJDb1dZSDhES3RsdWRGSnlrVUloKzZ1YU1wNU9pV05PZjFpZGtmdVNmWUJV?=
 =?utf-8?B?TnJ2bGVqRDc5L21Nb1JpeC9BQU9IazQvZVFLQ0dTSG8rd0xSTG52WWxOYU02?=
 =?utf-8?B?eUticnNIeFFMK3ZjVXZUeWo0RjZOR3lkVldFZlZmY2JnYlF2Nk9Qb1RtWWRw?=
 =?utf-8?B?d2s5VnZya0Fic3dxOEdBMURaaGVNUDBMdDY0SURJd1NQZ0xtdnNpT0p4TFIv?=
 =?utf-8?B?d1htQ2pqdnQ5YmRnTHp0MzNKcVcyaXJ0bitUQ0V0S0xrR3NrcUgwMXVvL0ly?=
 =?utf-8?B?dGNhVUJmbU4zMHBSWlZ5ekEwRXA3Q0x1YTNjTG1pNjRteDRBVG5McmNLbXFE?=
 =?utf-8?B?M2pLalhhbWVTdVpmN0ZzMW5sWitKMVJsTWVLNkhoaE5OL0dyaXRSQkl5cVc3?=
 =?utf-8?B?RFNjTnlqejJQby9Cci9CUVM1WmozeHUyOExXeTE5b0lMT2R2Z2Jjc0VNczUr?=
 =?utf-8?B?NW5jTFBBU1ZqdVo0a2ZUUXd1ZVB0TGtBa1Y3U3k2aHJuR2pMZW5RYzYxYktj?=
 =?utf-8?B?aER4NDE1eEsrdHhId1AwQjZpUTNxMkYyMU9DdEpzakJyQ1ZvWXd5OTEvZ2ZE?=
 =?utf-8?B?cTUrZ0NZTEx1aEhoQlVuYS91RDlmRlZNSWk0cy8xS3psM01aMDhtcHJRc3g1?=
 =?utf-8?B?eWpxallkSElxQzNQRXMreStNSkNBdHl3MjhZTHBrc0NtTnk0SlRvZW5uNnFw?=
 =?utf-8?B?dVptbmxiQWNyTmdlaEZOQUxGRW1uZnVWQzhEckx0Y1FSVFkxbGNpbnlrV2dk?=
 =?utf-8?B?aGlhbXZ5UEorMVFDWU93TTlWM0xWOURBUGtHZEVsWVNJcEN1YWoxWmpESTJV?=
 =?utf-8?B?R3NNcG04S1ZXL1p4azcvN3NuTVRmZHpVbUM2VHhnbW1MakRFc3BwaTVTZko3?=
 =?utf-8?B?ZGtJTStnT2x1OFFOR2hDQnRhN0R5VjI4eG52OG5mcW1hMElZVXo0VzlWZEZr?=
 =?utf-8?B?STNZZ3JXazYrLzdzMGhkd1VjbWVZU05sWWh1c3U5T25PNjhldUFnZC9WcmhS?=
 =?utf-8?B?TEJKeklzNjdoSXVKQy9XSlExWmNDaVBVaUEyQWgyUTFEZkYvU05aMGNHaXBV?=
 =?utf-8?B?RVNJMTEyeEFMdFJXM2VOZHZXREdDNVRFUXJHUEpySnluazZESUxiRVlJaTFu?=
 =?utf-8?B?aUtTaW82TFNmM3J5K1J1Z1hZZmtKYnhkRGdwakVha3Z3L1VvUTdwTXo3d2dp?=
 =?utf-8?B?NG9rWnJBWHN4YUtGWXhENnk1NURqTnp3U3ZwR01UbUlLMmdibHE1Z21laUE1?=
 =?utf-8?B?RCs0bCtBQzgrU1ArelFPV0JLR0lKOEhnRjY3aENDMmpuL25paHgyZjNYSzhr?=
 =?utf-8?B?VXFQZXNlWC8wNHJ6RHNQNmJrQnJyUFNIeTdvbU1oUUZPOHhPN3kwZWNaN0xF?=
 =?utf-8?Q?6GLM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf33090-7d11-47d7-c874-08db35ba4845
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 09:43:59.5286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KYkMPaDJfX0h+ViftmdVXlCdKEqamsxse/ZZy9DkeFCwVtCG4C7BdOEHhuqx4C9r7g4CYEbGwEmxShteVBBkXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7630
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFdlZG5lc2RheSwgNSBBcHJpbCAyMDIzIDEy
OjM4DQo+IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+IENjOiBkYXZlbUBk
YXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiBlZHVt
YXpldEBnb29nbGUuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsZW9uQGtlcm5lbC5vcmcN
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2MyAxLzRdIHZsYW46IEFkZCBNQUNzZWMg
b2ZmbG9hZCBvcGVyYXRpb25zIGZvcg0KPiBWTEFOIGludGVyZmFjZQ0KPiANCj4gRXh0ZXJuYWwg
ZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0K
PiAyMDIzLTAzLTMwLCAxNjo1NzoxMiArMDMwMCwgRW1lZWwgSGFraW0gd3JvdGU6DQo+ID4gK3N0
YXRpYyBpbnQgdmxhbl9tYWNzZWNfZGVsX3NlY3koc3RydWN0IG1hY3NlY19jb250ZXh0ICpjdHgp
IHsNCj4gPiArICAgICBjb25zdCBzdHJ1Y3QgbWFjc2VjX29wcyAqb3BzID0gdmxhbl9nZXRfbWFj
c2VjX29wcyhjdHgpOw0KPiA+ICsNCj4gPiArICAgICBpZiAoIW9wcyB8fCAhb3BzLT5tZG9fZGVs
X3NlY3kpDQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gLUVPUE5PVFNVUFA7DQo+ID4gKw0KPiA+
ICsgICAgIHJldHVybiBvcHMtPm1kb19kZWxfc2VjeShjdHgpOw0KPiA+ICt9DQo+ID4gKw0KPiA+
ICsjdW5kZWYgX0JVSUxEX1ZMQU5fTUFDU0VDX01ETw0KPiANCj4gRldJVywgSSBkaWRuJ3QgaGF2
ZSBhIHByb2JsZW0gd2l0aCB0aGlzIHBhcnRpY3VsYXIgbWFjcm8sIG9ubHkNCj4gVkxBTl9NQUNT
RUNfREVDTEFSRV9NRE8uIEJ1dCBpZiB5b3UncmUgZ29pbmcgdG8gcmVtb3ZlDQo+IF9CVUlMRF9W
TEFOX01BQ1NFQ19NRE8sIHlvdSBuZWVkIHRvIHJlbW92ZSBpdCBjb21wbGV0ZWx5Lg0KDQpyaWdo
dCwgSSB3aWxsIHJlbW92ZSBpdCBjb21wbGV0ZWx5LCBzaW5jZSBJIHdhbnQgdG8gcHJldmVudCBk
b2luZyBhIHJldHVybiBmcm9tIGEgbWFjcm8uDQoNCj4gLS0NCj4gU2FicmluYQ0KDQo=
