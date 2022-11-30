Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E390463DA0D
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 16:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiK3P5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 10:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiK3P5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 10:57:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B896314;
        Wed, 30 Nov 2022 07:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669823859; x=1701359859;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E/2ASbzlwqghXk+d1CVbPhH/tU7kjBGAmU0fxBfbFMU=;
  b=m+y9DpMO+HIBj8vvs0l/ZpnENDZL3LMDe2hzdCKKN9kQVK7rNF44DRlI
   xtb6MF8HFx8xtReZk8l1H7hoDlF0ZIF5rtYttUvgonZpScZji/S17U26A
   XPN0LXEzcL6O78s7VA+iivCG6ZBXQvI1YutKlLCupZPcxqMjnx9blM2hw
   vjdUu3coid9EQdRTr6Mn4c25NVHvAzJ/yBA3SIQMC4ZQ8EuecvRo0VHv9
   8CfqvmXwt6aMV9weNib/vOHIJ58ikPzmLbbqXziHqUFwCjmC8XOPjtJ8G
   r/ztyLCg85nVoj5X5pygInN0QGr4RMlpjqknHbklrPEjZcNsPg0VtjjfT
   w==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="125821796"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 08:57:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 08:57:36 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Wed, 30 Nov 2022 08:57:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFXh9UtrPXWWHkLTjFBivwhg+7Ty5UwwxFdmTI21J7Mw1veKtcuQdcwKuZhDznwEMPECdXTQe1HHuFepN8Ru7TUzamVd30cVHQRRTGZyqX1dINlOMuoKBkv8x2EXt/4hG5+7ha0HGLvol6JP7C1+Ym3OwTOfxfp653gTNQkVxKMGuTIPJshMYIfGrVTp/4AfnxnfKYzbtQyyWkt/VmCwPYO4glWuckRKH71S0sWUdZ659n163EVobKYZoNSh5ufLTYn46DtdmYSI4DCgZREOYnqG/q5aQcX9LlOnf7/J+mWIq9vqx6suBUa+pWwibaN73/MXuH7qIAueRKaTBSr3Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bjaYWtrI8UYqBos1F7geCuWw8CGhiNE9FKjj8yvTDVo=;
 b=D7dOCU4ol4A4yo18QI17fLOKD0WNt0bz18UDpCqNFOxD9Pi4iLrbUMkFC9AdEaqcYcJfXI6id7u+HTz7Pcfo1mm2KG08tpiokfTjoVU38T8wDQfaVIJEOvRzWTPGWMqlF0I2myJqqkDRK6K4f7agbBSh+YxWNj3twx+tw5GR6U+AUkjcp9+2WH5c34NovDeyU8M1d4ItIc1KWkzHl71iOl0fvZ7wDdrsoYJ2A2aBrX8MOGKakBikxW7QVqREuDOANFxvjFPcBHMwoKw19EQ0YYysHNrxE9va8lgXA8AnHi8A9BeZdc/f5cdTCaGNr2FAFIR42DPGwVWc73kdCioEmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjaYWtrI8UYqBos1F7geCuWw8CGhiNE9FKjj8yvTDVo=;
 b=YJGE+QJ8IAGMUHWFbltBjvxN8N3lnNQPTe3DtULxhBmHmt0apYKpYrjv8KY9JRiYsYw056XgVjJqDBuOxyMn+05wOuZN4kd+iD+OQB+Tt1Z4+ndxBC97U/r3jGLKyxC/RzcipjohcjJ1VB5akyiyINXgD/z4/oviLK0UUXFQgi8=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by SA0PR11MB4558.namprd11.prod.outlook.com (2603:10b6:806:9e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 15:57:35 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%10]) with mapi id 15.20.5857.023; Wed, 30 Nov
 2022 15:57:35 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Thread-Topic: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Thread-Index: AQHZA2vPxK4eDIuP5kOkg3W32g1dkK5U02GAgALOauA=
Date:   Wed, 30 Nov 2022 15:57:35 +0000
Message-ID: <MWHPR11MB1693C29AFEAE5386D0EE3AEFEF159@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221128205521.32116-1-jerry.ray@microchip.com>
 <20221128210515.kqvdshlh3phmdpxx@skbuf>
In-Reply-To: <20221128210515.kqvdshlh3phmdpxx@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|SA0PR11MB4558:EE_
x-ms-office365-filtering-correlation-id: 13bb3574-ebbc-434e-e275-08dad2eb990c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: afWDzNwHoSl0ArUljEzSjpgmFY5aSES3TWJ2qy8h7T+AagqBZXFDt1TWxkCs6cvVw4388tjH8iUaPMIgdt7YY4zuPkR0HtjxkXtisq1zyu2K5GdcXaKE+CeJ2m9f24I/M6Fxu9S9IfXRW2J996lEnE14iMGW7huwDUBQLrEvSq3APiKvqVQXpkw0Wj7bzNvjOP9ezE1Mglkt5yW3aIC+3U1YfYoSgg03G7rKIMvLuUUkwT7DhFJJmjdS94TCpknwDuOIj1Ko1+5knPsEAsGsPNDCq6QUAr5/6VqmSg09oEICKu0lq44w0pOZPTswr1S9wGK9V7mvgyaR5zceBj1d44dZWZSu/gnxBv3Qdl9PcMPw5D+eYpeLyl+XGyybqY3tyHo231CMvhefCwAWL/UYKcX+HFA7JD/xUJrLAnVTCp8WYQEFgX9d2W7H8vWFYD6h+JxcZRcmty4l59GCP2eOF+O5fFhCaAqHPieWUhA9SMUo8xiPbp1GHJyOtHuVFpFRLQ7J+OXY5d2tHcCw4CV6jFaqTRmQUuvdkV+rKq8U928KSAwC7p3OeQBOD6l8VgzMYwljXAo4R4+V7yE2WB+z5FQF/ggTtjg20Z14ny3TIFRjK3OtSP/KBzp7gA82BjE/ewlQlkEA6DOlVzlx596Nc3FVCfmmZ6ood23VZM3F5orOeCm9iu9oRA3yc61gsBikjKzKEhwjgOexM6/OYYLBzDu8UejU3zjPED79DKDBcUQRM3aeiNTzqRdxoGjesl2R
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(39860400002)(366004)(376002)(451199015)(6506007)(2906002)(6916009)(66476007)(4326008)(66556008)(41300700001)(54906003)(186003)(64756008)(316002)(8676002)(52536014)(8936002)(76116006)(9686003)(71200400001)(5660300002)(33656002)(86362001)(478600001)(26005)(66946007)(66446008)(7696005)(122000001)(38070700005)(38100700002)(83380400001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yxarYRalWUSs4eGmCqO43KBx/O22i/BEjZFt9QgTs1Wy4/rMizPlS6vAg4kG?=
 =?us-ascii?Q?0YEKU6jaTK3YIzM4o4VFT8zTDYP6cx37BRdsPy3Rh+/piJ8yFI+NJu9VdL4I?=
 =?us-ascii?Q?s5sF+HWfVmKndYl9ZAvwZGY81nghfNOGgc1wizqXT4vcn1m+DxF04GOTht82?=
 =?us-ascii?Q?VUKxrIHlh50wYdDbu+0RmBqbD0I3YhdTRk2nXgd7qHPRbnYo08R4fzchZ7jO?=
 =?us-ascii?Q?RanVU0H+dnN6++98F3IouxzCxNKmNuodxva+WonrtmYV+jQL5r1bjy4628c1?=
 =?us-ascii?Q?ph5SHG9HQrZO9BHQeF5mJOneqZGUBGIAIYwr7iopUyArV0YBFElcomaGwfdX?=
 =?us-ascii?Q?KIb8vlPhwyytClc5UWNtnJJ5lCFRUmrjhYhTq8OUQC2tFfGpjLtzHKMAX53p?=
 =?us-ascii?Q?BrzTqvHR5/UJVKQHPxXp92aBjZrkodUzAXh8132eOZU/HnCNWT46sCt3v9XB?=
 =?us-ascii?Q?QRvyWjlYnQ0zQytVRXiUQ9lWuZUTIvC3Ipfu9RpBzXT1VqeNp1VIVhBUab90?=
 =?us-ascii?Q?pzO9LZs61NtJTV/J/29kvl0sdMwBGeaAIc1sYw/bmhl7v1U/Rtusskc2nrBM?=
 =?us-ascii?Q?lQtuyru59XP30SQD4y3InnLZY8KydEta65NbEegyJoCH0FdSwu1t64VfWLYG?=
 =?us-ascii?Q?ilKiAiiOsnp5YAVrflysean6bBpJg/a78FSohYaUWAee1hQyacgzkAPX5SWR?=
 =?us-ascii?Q?RGlPl9BL4Lgk26/DjQ+kNH7+SQdvDaUOZ+xD/KhB3BAOO9s9L2nQfe4v2nct?=
 =?us-ascii?Q?TAIWMqyiFFjUrTNAGTR1LcJfKXS3yVkPUkOyrJ+l9QoxdneIP6rlgUSwpoXH?=
 =?us-ascii?Q?1+0XfrbPdY+nfNAel+1qGivudLP5SnKovuwdt9xYZb4QOVYOWRbd1Oxsf8Sy?=
 =?us-ascii?Q?Hm5bB2ABTcWDUlRgpzLaIZdm6Cs5RiaT383+3aqtatkdLU/y6pG8U72IEoVV?=
 =?us-ascii?Q?43FYw8gSwXrk08lOWSUuSCGpEYhpl/G/zhBZxCON5reu0MGbTj7DK8k21/un?=
 =?us-ascii?Q?31unMjyJD9ijg+Eu+PCErqzowd0m7hBkiInDW+SLGmCq7miiFhJmN8TizjkI?=
 =?us-ascii?Q?YipK78uY3E6wTRIje1Y5iO7e8kxhFVKN9rrwrG+BvgouON9SnRYIc0oHPlq0?=
 =?us-ascii?Q?Btgju73fkmyNr7PR3GDZtSfVDDkJ/F1Czkripgwlov5zHwOSLpexa70Q15AN?=
 =?us-ascii?Q?is2ehTIw4xJfknMCZ/zTxFiwpXxkV5lI/EM1eyXgq7iSbBMd/j9ZAK5yMjma?=
 =?us-ascii?Q?4Mndj+JLNyaAiKQXed//WLxNNj17lgUEw1GXLTGXhZ5iEJrGPzVbIGlAGmFr?=
 =?us-ascii?Q?7n6wFPqvTn0VJL3afTG7WoExZzCvGNT1Smt8cRB+bjXhSMUTaCEf2z+8uaKn?=
 =?us-ascii?Q?YS2whxwuSJ0ZK+uIeFmmklBpsGcMQCsbGXQwj/m1EGCnN0MBvosczc37VKYC?=
 =?us-ascii?Q?gVLsGx0QQWO8DGeUBT/b9tBOCOWumijLM3qQlmWMloyCO9cGagISbsEPCY8U?=
 =?us-ascii?Q?BACv9AtEFSbDL9g7xzONdZ1fCgRKGTSvP4a+fKCnKdyqh83qJNsICM/+wLZZ?=
 =?us-ascii?Q?Zrs5T4LraWW6eQT9kcgnmKtiXP1DoZJLLfamqhR7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13bb3574-ebbc-434e-e275-08dad2eb990c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 15:57:35.3096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ktpedLb3eH5NJiRFRmqY9ZMTgAGspGsOUYX2sHHGUjfI7okdakO9lnUXa2VOCqcHT0huW/NubKSEFsX79WZELA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4558
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>  static void lan9303_get_ethtool_stats(struct dsa_switch *ds, int port,
>>                                     uint64_t *data)
>>  {
>>       struct lan9303 *chip =3D ds->priv;
>> -     unsigned int u;
>> +     unsigned int i, u;
>>
>>       for (u =3D 0; u < ARRAY_SIZE(lan9303_mib); u++) {
>>               u32 reg;
>>               int ret;
>>
>> -             ret =3D lan9303_read_switch_port(
>> -                     chip, port, lan9303_mib[u].offset, &reg);
>> -
>> +             /* Read Port-based MIB stats. */
>> +             ret =3D lan9303_read_switch_port(chip, port,
>> +                                            lan9303_mib[u].offset,
>> +                                            &reg);
>
>Speaking of unrelated changes...
>

Cleaning up a warning generated from checkpatch

>>               if (ret)
>>                       dev_warn(chip->dev, "Reading status port %d reg %u=
 failed\n",
>>                                port, lan9303_mib[u].offset);
>
>...If lan9303_read_switch_port() fails, should we copy kernel stack
>uninitialized memory (reg) to user space?
>

Good catch.  I'll zero out the returned stat.

>>               data[u] =3D reg;
>>       }
>> +     for (i =3D 0; i < ARRAY_SIZE(lan9303_switch_mib); i++) {
>> +             u32 reg;
>> +             int ret;
>> +
>> +             /* Read Switch stats indexed by port. */
>> +             ret =3D lan9303_read_switch_reg(chip,
>> +                                           (lan9303_switch_mib[i].offse=
t +
>> +                                            port), &reg);
>> +             if (ret)
>> +                     dev_warn(chip->dev, "Reading status port %d reg %u=
 failed\n",
>> +                              port, lan9303_switch_mib[i].offset);
>
>Because the same, existing pattern is also used for new code here.
>

Ditto

>> +             data[i + u] =3D reg;
>> +     }
>>  }
>>
>>  static int lan9303_get_sset_count(struct dsa_switch *ds, int port, int =
sset)
>> @@ -1017,7 +1061,7 @@ static int lan9303_get_sset_count(struct dsa_switc=
h *ds, int port, int sset)
>>       if (sset !=3D ETH_SS_STATS)
>>               return 0;
>>
>> -     return ARRAY_SIZE(lan9303_mib);
>> +     return ARRAY_SIZE(lan9303_mib) + ARRAY_SIZE(lan9303_switch_mib);
>>  }
>>
>>  static int lan9303_phy_read(struct dsa_switch *ds, int phy, int regnum)
>> --
>> 2.17.1
>>
>
