Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268045E8D65
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 16:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiIXOmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 10:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIXOmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 10:42:53 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60088.outbound.protection.outlook.com [40.107.6.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972CB31DFE
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 07:42:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5EsADwn6fHo8zqGMbOCjjQw+BXBnAi2P5wziVdXDP0N/wWI9Gh/KB1GtP5e3pFsCpsvjUO8Nwjd7IpEzLCZKNmSDrMUd51thqE/goLSBm8o+b2joqNIam7+OmACVGmTZFwLY+IYzFwhi6bu9MgRNStDy/kZc9pZu9xK9XUuYI2y2EcGVjOSqtFud4cE5K74uep3NFMMo+BWKnMrCfmAe4ZpMBAHdQtYlxXsOMX5EjSt+pJMAlFeSS4V4lP5QkPEjQVLp6adjNTsVwyHoNrAcCBE0v62qJprJbmZNGcJvIpsPRKMVP9C3P0N3eBnRaoCVmjlB8UVbffSNtx19CSOVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z2MuSoRmehl6AaLZaU1aoEymPJMCBBftdtRH3BTuXH4=;
 b=C08UsrriFESPlm3AraLa3WKcBn6Uy7DfiMvLCrhVE161vaKw/KHmhD7mwhwEDSoa9bqtAmC2da/X88E9XPws4snA9o7sUzNeSfNoACa06h+G0gZ6mPclQz0T8A3m+Vf1U4uRFh37+TyoakzZ+kgnsWBGWwSkdM92G3wMA7sHqqyFM5ouhVkEdZYIAyfXf/C99GviRu53T5/iad1QaPpoW6atAGwB8/TSBQQ87IDLC1UmGVwTh5Kpd+GxEx3MVfxb0d8b+aJBH+F01Plmqa8qLhbym5U/CS65veuJMJPFI0HV+WKGxUAXyPD86yksACogU8vNlSpLlXiMM+XpMaXgug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2MuSoRmehl6AaLZaU1aoEymPJMCBBftdtRH3BTuXH4=;
 b=XNC1B2f8ewTesUAJJZj12buawZpREkHyQrT27SZSFu92SabuDzil6WCVFmtZhY47pljZjt2OOTVQzkj42ul4tbR9bV+ZFwfGRJS4b+pW76efawRQGaT9bLw4eKFKmH2FZSliDXkpcK87l7XniBCg+At2Ji2HxGDwR8rTkYY1PM4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7681.eurprd04.prod.outlook.com (2603:10a6:20b:286::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Sat, 24 Sep
 2022 14:42:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Sat, 24 Sep 2022
 14:42:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v2 08/10] net: dsa: qca8k: Pass error code from reply
 decoder to requester
Thread-Topic: [PATCH rfc v2 08/10] net: dsa: qca8k: Pass error code from reply
 decoder to requester
Thread-Index: AQHYzqz2VzoSaXDqfEqO+NZLedBiN63up4eAgAAC9IA=
Date:   Sat, 24 Sep 2022 14:42:50 +0000
Message-ID: <20220924144249.pz7577k3retgofjo@skbuf>
References: <20220922175821.4184622-1-andrew@lunn.ch>
 <20220922175821.4184622-1-andrew@lunn.ch>
 <20220922175821.4184622-9-andrew@lunn.ch>
 <20220922175821.4184622-9-andrew@lunn.ch>
 <20220923224201.pf7slosr5yag5iac@skbuf> <Yy8U71LdKpblNVjz@lunn.ch>
In-Reply-To: <Yy8U71LdKpblNVjz@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM9PR04MB7681:EE_
x-ms-office365-filtering-correlation-id: 728c39f6-0d3b-4299-48d3-08da9e3b0e1e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GeBC3dyrVxwwEM/nv//YYfPLX0xEq+kwtbeF0nSQyMCzV5gX0tD2ZVjODvcRk47XQ+AMK6SPZ9ePF0+kaRU155WEM9rrrf6IzUkhrEds87qoZFTrb2Z1QB2zGbRT+eXsNNoZf8BqZlwMwmhRh1PqTJFuD5L1tW8apEYGgRgNl1RIyg7NINC4AvnW4k/yUR+gsMTbKcVEG3FdmxBbvC/nOYD/VS0/I7nqWbig9rmpy35M0HDnpS+YotnqQMEAZ78LIb89IBblu7/QzQmDeTb0DsXMwORDza/k0+0SBGCB/6+5KGXudg8oT8IOh1YW1BNAhoh5tRVKHiQc43yaBqUcgoNUnV53i1NbIZfLqwCNadOE+7E1j7bBCT3qT+kLZbe2GVsXpBwZOPZpNxU/NDnkAu3lnZkxSnAXAvIpDHi1Da3rCHpKGkeKmIlRQw7Mf8RMC/NSLWtKkTn/y7JDm906BSohatj1x5fgiKxsqK0kln38S4JGv89C2EteA+jXQ+UWMRUFmYPDM3VjehF6o8c9BubI9zIFnx9MSGnLBdCXX0q7nLoPmUXQ1q3l4YqBYfi1wJprDVoZ0uzGd93CPfgySmp5u/LiHbtqhNgUVJaNsRuMBUtXKJfJRGB3zc1JdVzy9olObE81Mb1crXmpf/M8u92uuO0pEJo3l07eXCRejXObcZP9ysjHuOZbZcMucfazSbf8CFnmcbqen7z/xsuTadi4ccHOvB38M5SUqMSmj57lGGfXank+w7mlCR0kjzkrCAwD/jxK1eEN/0zOVFLfgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199015)(33716001)(86362001)(6916009)(38070700005)(478600001)(71200400001)(5660300002)(54906003)(316002)(64756008)(4326008)(66556008)(9686003)(6506007)(6486002)(66946007)(26005)(66446008)(6512007)(76116006)(8676002)(66476007)(38100700002)(186003)(1076003)(8936002)(122000001)(41300700001)(44832011)(2906002)(83380400001)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5E5Fhjm5rr6u5+6AZPIHVv6unNBrYcDoeoyd0cRTjf+Ru2qsY64nT63+VbQ/?=
 =?us-ascii?Q?xhASO5UvpvJVXaxIMac+cKXgv5Jt9hUlwMFqyG3onu9YRgHXD+2rSC9vEBrG?=
 =?us-ascii?Q?tERHl7iuYKSDbV+6uSij4uM2utGdCUDVhBkHaEyvZugL/rpK5GZ1T1oaH0xf?=
 =?us-ascii?Q?KjTXYUwAkk8vhfe7n9Thw6gfuFQGEajH5vVvARWH9CBnRQHK3cXOna+Bn03k?=
 =?us-ascii?Q?NHcTgfwomj4jJxs2BxlNczn00FuQXFXogW5WMrfn6vP4xBq5enu53ewt2c8i?=
 =?us-ascii?Q?Fkxod/O0E5SkKXO9YB90YGyIhxv+ywKv5TtqbAYzWnrw/xpgfOaKERfPMBEE?=
 =?us-ascii?Q?TCHjtlIy9/OtoidhV/bIf3i1qbqjfkC6R3tVABZCedwLNReqUc8XuXPs/zHx?=
 =?us-ascii?Q?xwAlt2/NIovS51sF46pPT6SxoXjkeDZhJX7YFLdV3QJKaE+iTj06vcMdjGqW?=
 =?us-ascii?Q?V6iD4t7oxsy0H662iMkD8vUwJ3PaAfnzcF+EVsUtK1/OS76wtR5ydp1wIuR2?=
 =?us-ascii?Q?JjqNs9wWjI6Q6VLA4fuAqaaDbg24Zo4mrQ2u7c9dNWcO87hOqzbp+EdlAGBV?=
 =?us-ascii?Q?MItNry0D80TWBFjY/UVXfaLo4usDUWwliadAcUWgt3iuuNNHvJeDMfbslBVr?=
 =?us-ascii?Q?rCY0rPWABE04cwKtna5GwYLOBYMci3igO5DJ6scUZvsnxIsGJoBvCFKSOsPq?=
 =?us-ascii?Q?fgqdPX/5PiMxjGbtvEi9w815v+ICDVpxYCLia3Im2MDbxjqi8ny/v/ftsteR?=
 =?us-ascii?Q?qllL/8vPRfPHMeeSxb14xOALWOUoxDNESDI9h0VZk+wZzo67d4mDEG6haLY6?=
 =?us-ascii?Q?zI/xKNuPAm7Oa6TctkbGggeFg82EpY1enBHBOPvNbbB66vuVJh9RE/VXpN8z?=
 =?us-ascii?Q?vSn68wcZpeE3hzm37fHKLJjp6k3Vt9U1alpKDpjQiKFEtFjOOd+nLhDnGhRW?=
 =?us-ascii?Q?c+PvqXFrW/oM/A9mpDK4y7bDilvufmaYr34Al+2sPqaIpOhGPf/kfsOvVJEu?=
 =?us-ascii?Q?UrkVTS7++MLBYGBUJDd/0X1hVxYOrCRUKDyGKY29moRFyNOmEORsWeOix/+T?=
 =?us-ascii?Q?j+dmkKKGVImPOjhftz7qRuXvMZ0qMlMGowdzKnFYpu5mBco80zAHDwPsCmz3?=
 =?us-ascii?Q?ObUCI3AFEMeTAPFls3uwrOn7afzr9Gs9ZT1qd3s3MhVlkQ/6Is8rR2lCTJps?=
 =?us-ascii?Q?Gzzdabjksr0G7YE1Bdg6Zu78Zn/TqlNeQXl4Tz5lXdryZjjPLPVjVQDK5bVK?=
 =?us-ascii?Q?ArwvICKAudyIPVMklCunjsEB/dMFp3Ss0gYI2DA8gVvDpO+6VAjyg1WcB3SO?=
 =?us-ascii?Q?HLHnqloXw4/jeyVY9iP4A9xOccRcPdk7zIqiy2U3IGcg3xH+8eXL5p47qATN?=
 =?us-ascii?Q?0RXJYRleKrE2c+sp4D0gRpXRvWVPvTb0QFU5ssxr+URrGTi0OQEcsZMpG0yf?=
 =?us-ascii?Q?/cbR8Dw3HvRCv3OGxKeQCE/dW1LFdiNQZ3lR9BCwyPl0bFIqnzYWwpGVIdpz?=
 =?us-ascii?Q?JbTZwX4i18Ez20qR2AH/Q1kw/WVDEK+10QsFjWfBHW5c1Z1mv65r114kxDgD?=
 =?us-ascii?Q?k4D0Z15qNlPfrb9rEtnJyNrVrbZvPAyZiMZFl7nr03YmXdtHIYrwzAhLl6V0?=
 =?us-ascii?Q?gQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <463B82A23191794482DE7A456DEEF7FA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 728c39f6-0d3b-4299-48d3-08da9e3b0e1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2022 14:42:50.3158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2RJDxztJoy7tsJleQ/WJLC/u5xdEPX6F1YpYExP3FnMTqqSHmYbQHYF8ar/BtiBi+gad92hAGNIuPXNiCFVxcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7681
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 04:32:15PM +0200, Andrew Lunn wrote:
> > My understanding of the autocast function (I could be wrong) is that
> > it's essentially one request with 10 (or how many ports there are)
> > responses. At least this is what the code appears to handle.
>=20
> The autocast packet handling does not fit the model. I already
> excluded it from parts of the patchset. I might need to exclude it
> from more. It is something i need to understand more. I did find a
> leaked data sheet for the qca8337, but i've not had time to read it
> yet.
>=20
> Either the model needs to change a bit, or we don't convert this part
> of the code to use shared functions, or maybe we can do a different
> implementation in the driver for statistics access.

I was thinking, as a complement to your series, maybe we could make the
response processing also generic (so instead of the tagger calling a
driver-provided handler, let it call a dsa_inband_response() instead).
This would look through the list of queued ds->requests, and have a
(*match_cb)() which returns an action, be it "packet doesn't match this
request", "packet matches, please remove request from list", or "packet
matches, but still keep request in list". In addition, the queued
request will also have a (*cb)(), which is the action to execute on
match from a response. The idea is that if we bother to provide a
generic implementation within DSA, at least we could try to make its
core async, and just offer sychronous wrappers if this is what drivers
wish to use (like a generic cb() which calls complete()).

This would also come hand in hand with the requests being allocated on
demand, which I think would simplify a bit the notion that an unexpected
response might trigger a match with an unsolicited request.=
