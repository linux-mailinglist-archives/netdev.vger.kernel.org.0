Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E78260186D
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiJQUAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiJQUA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:00:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E8F733D8;
        Mon, 17 Oct 2022 13:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666036820; x=1697572820;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kfn3jgVPglakM8RmZkOsEzMdefxXW1ZEd4K7qCBGaMU=;
  b=hmrKFpdFk7la90SI4XlzDUvQurklkd9WpjzU90s3o3mdoz7sgn73ZDtQ
   XAppV9jEEyTY9CGWLxIffOdYZWSfKGckbhCXR6kj/xc9yLwEReROoKhF0
   2q1WELX+Vnp/F213tR8xv+dt92kfSONwg0T3pRc43Lg4Lz7tU1rwMOLtN
   xP+WGrQBBRejxEkCnjOheYYSReyNZBD9/V6kYOKluBGBhXYT9ZGs0Wuid
   k7GclCsx/Oh98JPEN7zXNKAEBmASf06ZaSZXwVtNajxAOTa4ZPaxVP9Uv
   ubVlGSDw7xyRsGnulKhMLmZ384r+8LhzdxIPEkOF/WSlQoilZrbI4Gcb5
   A==;
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="179201418"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Oct 2022 13:00:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 17 Oct 2022 13:00:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 17 Oct 2022 13:00:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQlhByQ6jLSjlbblkKrwzq/UbTn2A2mKO1dIylm9kk0qWRV6V5MqMlNWAbBIPhYS4qR4aw3o4zNf+lSbWZNvg9W5si+LIvlmygshTYhHX6xnhzQmwtRQ+QEJEJyHEYvbAZodb6kGaWgCpwSnRuQfeSsC6q/9xg08jnB67XZq03UZcfeAVuySCqqGNW8lRDrILCjKunCzfuWJbkAv4EEoTqN2wWk0+KonPutxI1OjjDiWq9cj8l2CUgFk2yMR2TINBIRyUXvrrqLbajKeFgf2ITa0P10coCLISjobiuNvouKbGx0XiTg5/TCb3mgYyshvaDCMN8SPk5xgK4uXb9ehsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpLzFLoMI2h0FBknmLZK4rLR3yh7QwkOwHEuPmd4h0I=;
 b=jvu51QOJVDdYLWuyxFqU9MnOzqegHcU8YTEkz6UA3j3FDfsY+TPPDg6GYTMgAdjp/W+rwkBjQ9F96uHKdVZBt1P2JkgAIhBvDz8dn11AxkmAtvP97kTUXnAuEhNwX5/D9B5xQFBVhtxZ4eDw6S/nUlyEsHo0u8G+QY0C1IsAsmHnKPXQU+pu1jFJrPchmEJaFyzYYMrAlmuZep+rdQyKy+OG9bobawCQqwZyWOiIFOCOEFbr3+j938n5Is2q1x3yV756F6+r80qaw2sVESC5ya6L4UJk9k9WP2oQGaMpA7eyzhs5vTM9t0QgKU36W1d/HPEdvAOQvtRE0LJkZ+eswQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpLzFLoMI2h0FBknmLZK4rLR3yh7QwkOwHEuPmd4h0I=;
 b=umAgquV+C5TMZsjmAkb3hnSwosNKcVX20hzLsfw/x1by2pZyL5WuDmZpJDM7CdNXE+PW1q5iSKueyaDfrqyZBWwWNbCsSllolaCkAx9mAc1XZFnKXs8LJqh6/wTEinZf7u1FEOphyagJ7pAuOj6VrYtxGZRDhZnexpZeO6wzSfM=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by BN9PR11MB5465.namprd11.prod.outlook.com (2603:10b6:408:11e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 20:00:14 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::6599:7b75:c033:afcd]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::6599:7b75:c033:afcd%12]) with mapi id 15.20.5723.033; Mon, 17 Oct
 2022 20:00:13 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Thread-Topic: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Thread-Index: AQHY10fB8CyYFFC0ckOeRLuaLwivma4FI+pagA3zA6A=
Date:   Mon, 17 Oct 2022 20:00:13 +0000
Message-ID: <MWHPR11MB1693771FDBEFA284B490DF71EF299@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221008225628.pslsnwilrpvg3xdf@skbuf>
In-Reply-To: <20221008225628.pslsnwilrpvg3xdf@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|BN9PR11MB5465:EE_
x-ms-office365-filtering-correlation-id: 2f6ed1a2-3d34-4f33-e1f5-08dab07a346b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t4RtlaEDy4lwHN+jeE/uExJ8WDpNNAq8uQBhyZFBiBKXLQ/6RS/9SBhkWlATs6hpZgmTPy1gvNBRQKeIjume0Q2pIvK2RcFqwMMM+RVNzkBEXLLGxSGjzOQ8bdWJz8uW11IDpjCzlPwfvwcdTBzBPymLVyHeOfrabhwLa7lF6fV1sTFbcqiOKCPbj2zzgwmiK9keAhC7mLISyEinkfifMG4Zt0ar6HM/zGk8z+2Q/XzLWY4UpMM38zhYE1TQ/w0b3wP58RB0wj/DWc6y40zRryW0MIDPLhLhVaXN84gpCUUGK5sLGKJNO36u/rfrS1qSqCvvgWKE9twFN6FH2Ub2V79hh/gFuUxPGhIB/+aQblwW7gvnW3eTZJAUDs9bT8c8kFCsCLu4nR0mUz8P84kFZbedV1Wy27qPW/l4N17LndrcBg9ix5dBGz0kJKSJIKbV0RNJyNPtcPl3mrL1VQtiPKSQIuw8R+IVDPaGLTVNhUVuNWBfMVkB+1xv183f7c+fmyDsl2HJz//+JPsiWF/OAHOKzWYwVDGbZfEBspyz3NOxgNaleOGIE6lvIUDWJtjjzwvBl+4uXeEf0ULwuiBxxiGJ45o9zHlvu7YDY0Sd/7+oUGfGH2bbdvos6+93LfrKXwmGDOids99OoA3JbQphW7U5aP4JqovMAJmHgFI5mbtUtQxjYOG+ix7niuB/eI4wRKSK5o6YO5Jm1iQDjOkqUoCL3KDlKwmsePOfNyj7qCoK3J7EABJKHOTHr/xHrrtKoMV+YaItLJ5ZnJRpSj4WYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(6916009)(186003)(38070700005)(26005)(86362001)(122000001)(5660300002)(7416002)(38100700002)(2906002)(52536014)(41300700001)(8936002)(4326008)(55016003)(8676002)(64756008)(478600001)(9686003)(6506007)(7696005)(316002)(66556008)(66946007)(76116006)(66476007)(66446008)(54906003)(71200400001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0dVBGhno+L1H8p0Hq6sPdLKbK3yg0F3ZDf9S159O8gC2gYTiFr9JDoI3hUV1?=
 =?us-ascii?Q?OmbVYVZBKoC44Yz5QdDpE4TQIOLvcKCRRhkMir8a4Bqie/5IcpjP98cqcDtj?=
 =?us-ascii?Q?GZXIbLOFi/U3Dp+ZAqU0UaNvUDKaajwyUqy+cg6GAlL4LEAcqNMmZAnaGPjm?=
 =?us-ascii?Q?jCJ2MXO1bFvGHkdViPFnsct8KIDfNqnMdwsEgfPOJUlhfmbsJeEI10aXNdae?=
 =?us-ascii?Q?rBY87k8SNDd0PcDr+Xoh3EhxqF7LtmOxaGYSCbCOWcKiXV7QN8vS9q5q0dQO?=
 =?us-ascii?Q?2SYkRSyJm+/N7yZUxI8al1mkCaDnoTq3h1B2bZJFfSGzIheq/z63Dr19Bu9l?=
 =?us-ascii?Q?RhJraM126gp1mBAQ4ruu/1i5IyC5ChglHGWSG2BYeHo64RCfbXpkLN7c7/68?=
 =?us-ascii?Q?SNv4gJfYEVIvo03SAzEvFKEZm2M6QicFD6PT6S99YKcvy+p2w5Am/g6BMxL5?=
 =?us-ascii?Q?fN5RgItiE9XzFEJ81Cu5R0eG0VHCFL4Svhmgs6g/XA4EpG6O3mHgP3qtHB+h?=
 =?us-ascii?Q?dFCnSF6eR1xRrTfCBHpvdGwmcvbjbOF23ghwSgt5AjcQfsYDZttjWBi6Um9x?=
 =?us-ascii?Q?HplP4jUNmjojGAoljqN/N97A/cWSu55tXg9Gjz1p7nKafLBB3afSJhtsyECs?=
 =?us-ascii?Q?hpzC9YeVNkEMNcJLG5HcKEjJHXW1hpB+8NzC8mgbKlmqmps6IcDj/8sVg8JK?=
 =?us-ascii?Q?SKyXfAhV6sjKq0jLLKQznYW2WAEZ35D1UkZqtPPXrc299fn8tt1/FUxfx4LI?=
 =?us-ascii?Q?FiF1OyfbuDt9u3DQ4UgvDmC+wpWjDPIYBZGV5va759RIC1gm78QiPlcs6VWh?=
 =?us-ascii?Q?y0rPh8XrVYNLhVYSHuDDKOk0lO+riAebFfP5k4BPTfgAb86QWEdavVU3eAl8?=
 =?us-ascii?Q?M63htq6D1R3T6Iq8Iqs/bp7096ZBKSh04vRRDH0OysfoI8lpyK+27mSS3pw8?=
 =?us-ascii?Q?H1Bn5pnywx8VXsKjilKU2Zw3U9A1CUMLlEE1amS2hNF/UKgA8izNblaQcULj?=
 =?us-ascii?Q?oZOwsdWpTl6EcsgDmSaYpSk+H7myiMBalk4puKA7XJYBB8k+iG5FlTIbIdSm?=
 =?us-ascii?Q?C1w2pJHYv4GiE4isPJaia9DQ0rdxGbvx088BN/LDm8lCkpEZ081UxjsdA3gp?=
 =?us-ascii?Q?5bU0WAjxuDTLqxKfZrVW3HiJ7FAjlgIJFXrayjJ7gUlDcjHr7BX126immYLg?=
 =?us-ascii?Q?grm+t64ZHGSgHqdlxIFvf/trDvyLQz8VVFSab5Tgt2odhWoM/ZbqbYCUztXo?=
 =?us-ascii?Q?UjosA5kUVAenBSMUWeX82XUnd88UFf5JqdzCGalcfaKWwqoEzdTKKBD1+JGi?=
 =?us-ascii?Q?PsRYPw0+zrJJKTMSUeADZzpEbWjtdXZLk8lUot81TN62zpN/4hJTdLYhxgxW?=
 =?us-ascii?Q?6pKk6pOUmDEOrwFDNsdSOXeBH5RLqXNhZyO6KzlQ5Y4hTbU5KDeP+E2IC9Aw?=
 =?us-ascii?Q?PLT4JePabpujDtSIvJlaD3NtV05VPbvdRgij4Mr/JX9etQuM3N0AAnIb8gca?=
 =?us-ascii?Q?ulFyNT+0aY7AoMATLrgzRYYXCYbiWabTAXYW5d7LsZds++wfe2tba5XUMGZr?=
 =?us-ascii?Q?x++Qqe7D8C+/LXjs6X59u9L+dZbMZa0dkQJ4C9ti?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f6ed1a2-3d34-4f33-e1f5-08dab07a346b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2022 20:00:13.8174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ABDzmCVW3ADurlXLcvIXwGXmH6gljnQv/a8WCA2ITuG8vCu2KyuBFHy/LsmZsNPPM0bwisoHBnTxr0TkpXnG0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5465
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> ---
>> v3->v4:
>>  - Addressed v3 community feedback
>
>More specifically?
>

- Old lan9303.txt file is totally removed rather than containing text that
  redirects the user to the microchip,lan9303.yaml source file.
- Drop "Tree Bindings" from title
- Drop quotes from dsa.yaml reference line.
- Modified the compatible second enum to include a second string.
(( I now realize this is not what was being asked for and have made
  it a single enum with 4 items, removing the oneOf. ))
- Drop "gpio specifier for a" in reset-gpois description
- added a default: property to the reset-duration item and set it to 200.
- Drop "0" from the ethernet name.  Split the MDIO and I2C examples into
  two so that the number is no longer needed.
- Placed the reg property to be directly following the compatible string
  in the mdio node.

>> +examples:
>> +  - |
>> +    #include <dt-bindings/gpio/gpio.h>
>> +
>> +    // Ethernet switch connected via mdio to the host
>> +    ethernet {
>> +        #address-cells =3D <1>;
>> +        #size-cells =3D <0>;
>> +        phy-handle =3D <&lan9303switch>;
>> +        phy-mode =3D "rmii";
>> +        fixed-link {
>> +            speed =3D <100>;
>> +            full-duplex;
>> +        };
>
>I see the phy-handle to the switch is inherited from the .txt dt-binding,
>but I don't understand it. The switch is an mdio_device, not a phy_device,
>so what will this do?
>
>Also, any reasonable host driver will error out if it finds a phy-handle
>and a fixed-link in its OF node. So one of phy-handle or fixed-link must
>be dropped, they are bogus.
>
>Even better, just stick to the mdio node as root and drop the DSA master
>OF node, like other DSA dt-binding examples do. You can have dangling
>phandles, so "ethernet =3D <&ethernet>" below is not an issue.
>

I can remove the phy-handle, but I'm trying to establish the link between
this ethernet port and port0 (the CPU port) of the lan9303.  The lan9303
acts as the phy for this ethernet port and I want to force the speed and
duplex of the link to be 100 / full-duplex.

>> +        mdio {
>> +            #address-cells =3D <1>;
>> +            #size-cells =3D <0>;
>> +            lan9303switch: switch@0 {
>> +                compatible =3D "smsc,lan9303-mdio";
>> +                reg =3D <0>;
>> +                dsa,member =3D <0 0>;
>
>Redundant, please remove.
>

Okay.  I can remove the "dsa,member =3D <0,0>;" line.

>> +                ethernet-ports {
>> +                    #address-cells =3D <1>;
>> +                    #size-cells =3D <0>;
>> +                        port@0 {
>> +                            reg =3D <0>;
>> +                            phy-mode =3D "rmii";
>
>FWIW, RMII has a MAC mode and a PHY mode. Two RMII interfaces connected
>in MAC mode to one another don't work. You'll have problems if you also
>have an RMII PHY connected to one of the xMII ports, and you describe
>phy-mode =3D "rmii" for both. There exists a "rev-rmii" phy-mode to denote
>an RMII interface working in PHY mode. Wonder if you should be using
>that here.
>

"rev-rmii" does make more sense.  And yes, in this configuration the rmii
port of the lan9303 is acting as the PHY end.

>> +                            ethernet =3D <&ethernet>;
>> +                            fixed-link {
>> +                                speed =3D <100>;
>> +                                full-duplex;
>> +                            };
>> +                        };
>> +                        port@1 {
>> +                            reg =3D <1>;
>> +                            max-speed =3D <100>;
>> +                            label =3D "lan1";
>> +                        };
>> +                        port@2 {
>> +                            reg =3D <2>;
>> +                            max-speed =3D <100>;
>> +                            label =3D "lan2";
>> +                        };
>> +                    };
>> +                };
>> +            };
>> +        };
>> +
>> +  - |
>> +    #include <dt-bindings/gpio/gpio.h>
>> +
>> +    // Ethernet switch connected via i2c to the host
>> +    ethernet {
>> +        #address-cells =3D <1>;
>> +        #size-cells =3D <0>;
>> +        phy-mode =3D "rmii";
>> +            speed =3D <100>;
>> +        fixed-link {
>> +            full-duplex;
>> +        };
>> +    };
>
>No need for this node.
>

Without this, what does the port0 entry below have to point to?
How do you establish the device tree linkage between the ethenet
MAC and the rev-rmii PHY it connects to?

>> +
>> +    i2c {
>> +        #address-cells =3D <1>;
>> +        #size-cells =3D <0>;
>> +        lan9303: switch@1a {
>> +            compatible =3D "smsc,lan9303-i2c";
>> +            reg =3D <0x1a>;
>> +            ethernet-ports {
>> +                #address-cells =3D <1>;
>> +                #size-cells =3D <0>;
>> +                port@0 {
>> +                    reg =3D <0>;
>> +                    phy-mode =3D "rmii";
>> +                    ethernet =3D <&ethernet>;
>> +                    fixed-link {
>> +                        speed =3D <100>;
>> +                        full-duplex;
>> +                    };
>> +                };
>> +                port@1 {
>> +                    reg =3D <1>;
>> +                    max-speed =3D <100>;
>> +                    label =3D "lan1";
>> +                };
>> +                port@2 {
>> +                    reg =3D <2>;
>> +                    max-speed =3D <100>;
>> +                    label =3D "lan2";
>> +                };
>> +            };
>> +        };
>> +    };
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 5d58b55c5ae5..89055ff2838a 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -13386,6 +13386,14 @@ L:   netdev@vger.kernel.org
>>  S:   Maintained
>>  F:   drivers/net/ethernet/microchip/lan743x_*
>>
>> +MICROCHIP LAN9303/LAN9354 ETHERNET SWITCH DRIVER
>> +M:   Jerry Ray <jerry.ray@microchip.com>
>> +M:   UNGLinuxDriver@microchip.com
>> +L:   netdev@vger.kernel.org
>> +S:   Maintained
>> +F:   Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
>> +F:   drivers/net/dsa/lan9303*
>> +
>
>Separate patch please? Changes to the MAINTAINERS file get applied to
>the "net" tree.
>
>>  MICROCHIP LAN966X ETHERNET DRIVER
>>  M:   Horatiu Vultur <horatiu.vultur@microchip.com>
>>  M:   UNGLinuxDriver@microchip.com
>> --
>> 2.25.1
>>
>

Regards,
Jerry.
