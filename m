Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D921F63B2A8
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 20:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbiK1T6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 14:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbiK1T6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 14:58:04 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2043.outbound.protection.outlook.com [40.107.20.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD17140F2
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 11:58:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvcyF8A6juAkScxyjVcbRFJI2FWMjKhWye8uCR3sviS0ohTY6xo9DaywHX3Z3J9fC1F/Bohgrr4KexioydH+VBoHPJpWyv+cuaxP6WpfJeTYEeAzAN0wSxMEztZwNgjyWr/q8sjnFPK5gM7+vNqJooWJ5ufFMhN08xgE479LHagai2JxF58sFI6HuLVNGEWv3V0kkEp/doEBhNU+8lxY841DojdsCvwz/dSJY+xhkc+1kLjKwzy+aap6oVMJuWiz5WdHOGoLU6mFBHc63enqHhirSIWWVz8U2PuzdXkG1/KxH+T4EL2sgUQCbJV0U2PtIoeR8+sTx+KgsxFJaokfMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MEgNbK1Mo7MkvoFuFriN9LX9s1GqqPs8/5sL4DtTVK0=;
 b=e53cJ5ieO6gcPmvFbqZnWpayviI+aOlIG3XdnzLhf/rZ0hZ5eSwxDsDRcMhyw/yCZS9DKoMCDTLIlmw7QeLSA8svw1jpecyv13Z7YdMk0Mo/riMOFui68iq70vidYZVXL+DXa1Q+l/DJg+7x28hcQyDJZvSVwdr7bw1nHct3TO3XxqmtG9amaKd5i1/BALW3ug9T/LjOfTX+Cv9D5vPpwDkxdbUQVw3wvroNVQIKkAMusDwrFftCzvuC1WKchQ+r34NpfH1v1ViuTdaS+ILq3PYGTRy02HdGiV6s2v0oOsX3UCDpAIM45s9J/kq2D6Jm2+U1PgU/lHxIdwMqCsWvmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MEgNbK1Mo7MkvoFuFriN9LX9s1GqqPs8/5sL4DtTVK0=;
 b=p7bdZ/fSiXKjjWLY4z+Irsjalpo+VDt8BrF1VWPeDYl7ynf/bYhC1eRpVtmlXrTnKY877eFUgMjBk1aOCQAtdot11kIyzpFgI0kdr4VFNGHGsgAr+uXH7Uu3Cb2YPNnLiICe2yHr5fZo2MXPP0SM94GIYnQhNvLfdoPmj1xpg/mDjbHlIKjFTVlpPhmxY4ZR9Jdbae3BiBkL7NLmHtM0Q1gQwRFgvtsV/17pvzx9c22GE0uv7Y5QQrZoK9NyRdE8TVII7XShsHL0dgVsgsIdxarEhWcu1feyV1GF8oC0ER6W++VV5byYe8ve5SjmYI+qw9Lwx5S6ospumhtBRtugcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PAVPR03MB9480.eurprd03.prod.outlook.com (2603:10a6:102:303::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Mon, 28 Nov
 2022 19:57:59 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 19:57:59 +0000
Message-ID: <8ba08f04-978c-6a0e-6ecb-ec88da971723@seco.com>
Date:   Mon, 28 Nov 2022 14:57:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: status of rate adaptation
Content-Language: en-US
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
 <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
 <CAJ+vNU2i3xm49PJkMnrzeEddywVxGSk4XOq3s9aFOKuZxDdM=A@mail.gmail.com>
 <b336155c-f96d-2ccb-fbfd-db6d454b3b10@seco.com>
 <CAJ+vNU1-zoug5CoN4=Ut1AL-8ykqfWKGTvJBkFPajR_Z1OCURQ@mail.gmail.com>
 <CAJ+vNU2pzk4c5yg1mfw=6m-+z1j3-0ydkvw-uMgYKJC28Dhf+g@mail.gmail.com>
 <af134bf0-d15e-2415-264b-a70766957734@seco.com>
 <CAJ+vNU2zJuujdU-epsm30C+VCBVNHWVs9CML7FUYni5VUTiJkw@mail.gmail.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <CAJ+vNU2zJuujdU-epsm30C+VCBVNHWVs9CML7FUYni5VUTiJkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0062.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::7) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PAVPR03MB9480:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d16033-c905-4657-ec17-08dad17ad856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: smuTJWobxniODthMlx7cilqmcKmKtKC0DX/JeifY8QNbWNptF7sK9WCY2ySWloTgjVaXuATPGPTJkv86rc8iT5gKxATlC2qbOPlb3aNwMU4mDl3yRi1TzmpnmRRboQMeMm513AaHmqWM5+mnCkdWEqWpSUCqVd1M/LfFebGf3ahN7EUFTdbNcKEG11BRsI53IkyqfZheVwThVRBUaUIb+cfkpd0cXGD5BEGFLgbdQ8GScgCKI7iP4xXEpaFAmrgOjem2P2+SYwJGV99FYHuz6WuF81CY79ACfGNc4i5+csWbjrZ2tkvuoI7F4dpfqaEy2uxPgRBo5KVm4evsxafiE7P+2JHClmtF7LVVeuKVEnKhEctfvTcNijeUCTCK+PRSMLVBvB8+gkPvDNN8ZBUD6yCkX1/Bx4OujlgQWbqptYjenzubdsTT2wEy7U0d+AEphJI01Cr7liLbOna9gY23CA7WylTHa3SDWcnG07f0NhuBNrabhIIM0+TfLE94bBDEkVzv+w8BoRRsjyYer9wBqwKcxtafCtYgFr3fceCnUqQlxzvrxDBoQq9GAWHJjz4FQZ4sDCkJEiSiXLMI5rVTEyhJgfi48tFQf/wJEYVkBM49wooFfx0/KhPAAKvMRwXmPBI98XKY6LZq76ODz9+h6uLA3B+5T4dObiTGr8LT40n5WKW2dpoca4fwWrZS1RKKigaXP6QSVvh1MKXNOQ6Mp9rIj3bRekkmvv6wvbGICey6OWrkKMuYbb6Ci21wk/JpFbSsU/UPU3theIVJFhL35wgdwzrB9GxEr3afBqP8Uio=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(39850400004)(396003)(346002)(376002)(451199015)(186003)(6512007)(86362001)(31696002)(966005)(36756003)(6486002)(54906003)(52116002)(6506007)(6666004)(53546011)(5660300002)(478600001)(26005)(8936002)(6916009)(44832011)(30864003)(316002)(4326008)(19627235002)(2906002)(8676002)(66946007)(66556008)(41300700001)(66476007)(3480700007)(38350700002)(2616005)(83380400001)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlBvbEcvTkZtYnkvZ0VNblh2em5vaWJ3RTFCTVVMTUsydTY1dmd3V2tBdm8y?=
 =?utf-8?B?ZFdVdUg5UXAyRXZBNEZFVnJYeUtxdWxFSFJ6eG5UQW80UzZDTmxITkdNRSt6?=
 =?utf-8?B?MVZoNllIOXJsTXFmNTJoajZRcExiNFVNall3eVgrdko3b2U1dkg4ZEoxNGdG?=
 =?utf-8?B?SUFCQnY1MU1IVDVqbnp1c2hTaW9XWW1KSTkzdmZpQXNkTFZzblJlRXAwM0Ix?=
 =?utf-8?B?a3luaHFtVjlheGhmdlZzTW9RMDFJZ0x1TTNBS1BNaTJVRWdUbUJzUllnanJw?=
 =?utf-8?B?QllUVGJ1Qk8rTlFFUk1STUVIeC9oaTQzVUhZZXN2dFQrNmMzT2JVVXA0eFFj?=
 =?utf-8?B?amVIdlFpMzUvMDBCV2NHMVZLL0lBSFdsSmxhSUNkakJraFJHU2R1bDFtVWVX?=
 =?utf-8?B?OW1IREpGb2RZS0xHRk9XSFJPdTc1NU9Bdk9zNFArNkNBQlc2RnlpUEhpOURy?=
 =?utf-8?B?YTIzZTBCRHJrNG1uWDExWENGSC9HcXRveGFKa2czVFJacDBUQWtmZ2g3RUl6?=
 =?utf-8?B?NkY5Qkd3Z3lzdy91Vi9hQmRjd0I1bzFuODdsRXY3eWM3aHJLQ2NLb21jbFFu?=
 =?utf-8?B?NFVXSFdNTlFRVVAvZUM2a3c1ZHJURkJ1cWNrZ2RCMktMMHk2TmVvb3MwbTlF?=
 =?utf-8?B?SmNUZFJzQ3ppbHpEYVM5YSs4WXB6NzFTWEY4VmpLSzBXT0NaTnhUZzVBb25J?=
 =?utf-8?B?WEp5anpmWm81N3FVQ0JLZE5BWG1MRkdFNzBmVEJEazZxbUgwVkNBK05wSWsw?=
 =?utf-8?B?YWRKdXRkOVQyWmw5THFJNHoySnFWRXBETkp5L3oyKzRnUCtvOGtwTEpNUG04?=
 =?utf-8?B?alYxSGp3OE52YWxyQ2o4K0FoQkQ4QTlSZHFnZ05PNGRaME91L0xWTENiQmVz?=
 =?utf-8?B?Z3RyeCswRkphLzc1aFFtVHNabnl4NVpRNUFYQmtmdHhVNmFyOW5jbGpnbytH?=
 =?utf-8?B?cGJCM3ZObE9WMXczcHI0c1lHQUJNOERaVUttTHFhWnl1ZmU0Vy9HZGt4V2d4?=
 =?utf-8?B?d2dVcFdwODllcmpNZDVqUW03N244ODhBT2xGdm1sdVFrSCs4R29kWXIwcG1G?=
 =?utf-8?B?QXVRWXFsQ3BHM2Jzb0RicDFSSUIvbzE1UWd0aVZ5UUdJOSszNnRqd3ZlL0NF?=
 =?utf-8?B?ZEFkWDBrOGRrdzBaWGNteWxLdEE3NGpnNVU4NlVHcjZqQUduRUlJVDB0RnBE?=
 =?utf-8?B?OGU5ZDB1cE5mQzI3bU1CTFdvNGZsMGh5WU9kK1JPOU5jajNKTFcwUXJnYnpS?=
 =?utf-8?B?dkkxdE8rbDk1Y2JkcVdWN2k2WGRUeGwvbXg4Y0RuL3JNTHN5TzFEcnNqUEp3?=
 =?utf-8?B?Yi9idVNmdDQyM3p1RDQyb0dQTHphR2FFcWNOZENRdlQ0T1ArVGsvUXMxbVJi?=
 =?utf-8?B?YjY1aHdrK0JLVkQ1UC80WTlXakxXWDE1VVdSMXpheDVoZUw3MUliVUV5bVpL?=
 =?utf-8?B?cjhCbm9vZTIrV1JQWDZacUJxOUc4QlFxb1NPSkxHbzhYT21ZZEo2eVU2WkxZ?=
 =?utf-8?B?b3h0M1RIOFZYYjI1cW9nb29sc2U4akIrRzNLeVFyQXdHUXJqNlZlNUxsZTdx?=
 =?utf-8?B?ZHRDMmNrRWVoMVNYaVgzMURITVkzWUMxUm1UellQMHpXVlU5R2FBejFJOGM5?=
 =?utf-8?B?VjQxeG92V25TUlJ4SG4zWUtVOU1PQkMxakpKMC9DaFp3djFwVTBJMnZuaTlS?=
 =?utf-8?B?TlE0eEpXdVZSVTJvVnhkZDEzUGIxRG5Hb3RkME4wbDJqbWlWNmk3SSt4WGxB?=
 =?utf-8?B?bmFPQ1RRaEVkcnNPZlY5RmdxdVJ3M2d3UytObXIwRGpPeTVWSnkyNDR6cmVm?=
 =?utf-8?B?ZVVSVGYwdkFoTVh1UEp1aStaUFk1dEZ1UlQ0aStWVDc1dTZkVmEwZmc5MlN6?=
 =?utf-8?B?U0c2OTJ5cU51YU1UWDNXbmU0bjRERCtzRFdiVUNWNzZxdk0xUHlUSEllL2Z4?=
 =?utf-8?B?Mzl0bFJPSW9ycHZBQWoyYmZkWEp5ZEJCMnBWeVVtalZUS2MyQ2JPYWNvbzgw?=
 =?utf-8?B?TGhTN1h1UXE4eTBETGVkRXg0L0RIOWpDcXU2eVhueUdFR0ZvK1I5MXVEbHJU?=
 =?utf-8?B?ZXJsMGtycUpUeDBhNWY3ZXo1NUFSTGtsdThMMlFpc09oc2dnNkhtZDhpMWVr?=
 =?utf-8?B?cW9KcXZGaWZ2bWs2N0tYenV6M1YyaVZldUMwU05mb1AvcmxERDRzNDJ5bEVk?=
 =?utf-8?B?VGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d16033-c905-4657-ec17-08dad17ad856
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 19:57:59.1053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWLN/SxnMSL5X/kYl+8UcZfSr3uOYxaCZ5Z8DKFdfSOcCokZRxNU1xZWwwzKyf43DlKUJV5j80HNJzgziZOMNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR03MB9480
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tim,

On 11/17/22 18:42, Tim Harvey wrote:
> On Thu, Nov 17, 2022 at 7:38 AM Sean Anderson <sean.anderson@seco.com> wrote:
>>
>> On 11/16/22 17:37, Tim Harvey wrote:
>> > On Mon, Nov 14, 2022 at 11:33 AM Tim Harvey <tharvey@gateworks.com> wrote:
>> >>
>> >> On Fri, Nov 11, 2022 at 2:38 PM Sean Anderson <sean.anderson@seco.com> wrote:
>> >> >
>> >> > On 11/11/22 17:14, Tim Harvey wrote:
>> >> > > On Fri, Nov 11, 2022 at 1:54 PM Sean Anderson <sean.anderson@seco.com> wrote:
>> >> > >>
>> >> > >> On 11/11/22 16:20, Tim Harvey wrote:
>> >> > >> > On Fri, Nov 11, 2022 at 12:58 PM Sean Anderson <sean.anderson@seco.com> wrote:
>> >> > >> >>
>> >> > >> >> On 11/11/22 15:57, Sean Anderson wrote:
>> >> > >> >> > Hi Tim,
>> >> > >> >> >
>> >> > >> >> > On 11/11/22 15:44, Tim Harvey wrote:
>> >> > >> >> >> Greetings,
>> >> > >> >> >>
>> >> > >> >> >> I've noticed some recent commits that appear to add rate adaptation support:
>> >> > >> >> >> 3c42563b3041 net: phy: aquantia: Add support for rate matching
>> >> > >> >> >> 7de26bf144f6 net: phy: aquantia: Add some additional phy interfaces
>> >> > >> >> >> b7e9294885b6 net: phylink: Adjust advertisement based on rate matching
>> >> > >> >> >> ae0e4bb2a0e0 net: phylink: Adjust link settings based on rate matching
>> >> > >> >> >> 0c3e10cb4423 net: phy: Add support for rate matching
>> >> > >> >> >>
>> >> > >> >> >> I have a board with an AQR113C PHY over XFI that functions properly at
>> >> > >> >> >> 10Gbe links but still not at 1Gbe,2.5Gbe,5.0Gbe,100M with v6.1-rc4
>> >> > >> >> >>
>> >> > >> >> >> Should I expect this to work now at those lower rates
>> >> > >> >> >
>> >> > >> >> > Yes.
>> >> > >> >
>> >> > >> > Sean,
>> >> > >> >
>> >> > >> > Good to hear - thank you for your work on this feature!
>> >> > >> >
>> >> > >> >> >
>> >> > >> >> >> and if so what kind of debug information or testing can I provide?
>> >> > >> >> >
>> >> > >> >> > Please send
>> >> > >> >> >
>> >> > >> >> > - Your test procedure (how do you select 1G?)
>> >> > >> >> > - Device tree node for the interface
>> >> > >> >> > - Output of ethtool (on both ends if possible).
>> >> > >> >> > - Kernel logs with debug enabled for drivers/phylink.c
>> >> > >> >>
>> >> > >> >> Sorry, this should be drivers/net/phy/phylink.c
>> >> > >> >>
>> >> > >> >> >
>> >> > >> >> > That should be enough to get us started.
>> >> > >> >> >
>> >> > >> >> > --Sean
>> >> > >> >>
>> >> > >> >
>> >> > >> > I'm currently testing by bringing up the network interface while
>> >> > >> > connected to a 10gbe switch, verifying link and traffic, then forcing
>> >> > >> > the switch port to 1000mbps.
>> >> > >> >
>> >> > >> > The board has a CN9130 on it (NIC is mvpp2) and the dt node snippets are:
>> >> > >> >
>> >> > >> > #include "cn9130.dtsi" /* include SoC device tree */
>> >> > >> >
>> >> > >> > &cp0_xmdio {
>> >> > >> >         pinctrl-names = "default";
>> >> > >> >         pinctrl-0 = <&cp0_xsmi_pins>;
>> >> > >> >         status = "okay";
>> >> > >> >
>> >> > >> >         phy1: ethernet-phy@8 {
>> >> > >> >                 compatible = "ethernet-phy-ieee802.3-c45";
>> >> > >> >                 reg = <8>;
>> >> > >> >         };
>> >> > >> > };
>> >> > >> >
>> >> > >> > &cp0_ethernet {
>> >> > >> >         status = "okay";
>> >> > >> > };
>> >> > >> >
>> >> > >> > /* 10GbE XFI AQR113C */
>> >> > >> > &cp0_eth0 {
>> >> > >> >         status = "okay";
>> >> > >> >         phy = <&phy1>;
>> >> > >> >         phy-mode = "10gbase-r";
>> >> > >> >         phys = <&cp0_comphy4 0>;
>> >> > >> > };
>> >> > >> >
>> >> > >> > Here are some logs with debug enabled in drivers/net/phy/phylink.c and
>> >> > >> > some additional debug in mvpp2.c and aquantia_main.c:
>> >> > >> > # ifconfig eth0 192.168.1.22
>> >> > >> > [    8.882437] aqr107_config_init state=1:ready an=1 link=0 duplex=255
>> >> > >> > speed=-1 26:10gbase-r
>> >> > >> > [    8.891391] aqr107_chip_info FW 5.6, Build 7, Provisioning 6
>> >> > >> > [    8.898165] aqr107_resume
>> >> > >> > [    8.902853] aqr107_get_rate_matching state=1:ready an=1 link=0
>> >> > >> > duplex=255 speed=-1 26:10gbase-r 0:
>> >> > >> > [    8.911932] mvpp2 f2000000.ethernet eth0: PHY
>> >> > >> > [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
>> >> > >> > [    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
>> >> > >> > supported 00000000,00018000,000e706f advertising
>> >> > >> > 00000000,00018000,000e706f
>> >> > >> > [    8.934349] mvpp2 f2000000.ethernet eth0: mac link down
>> >> > >> > [    8.948812] mvpp2 f2000000.ethernet eth0: configuring for
>> >> > >> > phy/10gbase-r link mode
>> >> > >> > [    8.956350] mvpp2 f2000000.ethernet eth0: major config 10gbase-r
>> >> > >> > [    8.962414] mvpp2 f2000000.ethernet eth0: phylink_mac_config:
>> >> > >> > mode=phy/10gbase-r/Unknown/Unknown/none adv=00000000,00000000,00000000
>> >> > >> > pause=00 link=0 an=0
>> >> > >> > [    8.976252] mvpp2 f2000000.ethernet eth0: mac link down
>> >> > >> > [    8.976267] aqr107_resume
>> >> > >> > [    8.988970] mvpp2 f2000000.ethernet eth0: phy link down
>> >> > >> > 10gbase-r/10Gbps/Full/none/off
>> >> > >> > [    8.997086] aqr107_link_change_notify state=5:nolink an=1 link=0
>> >> > >> > duplex=1 speed=10000 26:10gbase-r
>> >> > >> > [   14.112540] mvpp2 f2000000.ethernet eth0: mac link up
>> >> > >> > [   14.112594] mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full
>> >> > >> > - flow control off
>> >> > >> > [   14.112673] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>> >> > >> > [   14.118198] mvpp2 f2000000.ethernet eth0: phy link up
>> >> > >> > 10gbase-r/10Gbps/Full/none/off
>> >> > >> > [   14.139808] aqr107_link_change_notify state=4:running an=1 link=1
>> >> > >> > duplex=1 speed=10000 26:10gbase-r
>> >> > >> >
>> >> > >> > # ethtool eth0
>> >> > >> > Settings for eth0:
>> >> > >> >         Supported ports: [ ]
>> >> > >> >         Supported link modes:   10baseT/Half 10baseT/Full
>> >> > >> >                                 100baseT/Half 100baseT/Full
>> >> > >>
>> >> > >> 10/100 half duplex aren't achievable with rate matching (and we avoid
>> >> > >> turning them on), so they must be coming from somewhere else. I wonder
>> >> > >> if this is because PHY_INTERFACE_MODE_SGMII is set in
>> >> > >> supported_interfaces.
>> >> > >>
>> >> > >> I wonder if you could enable USXGMII? Seems like mvpp2 with comphy
>> >> > >> should support it. I'm not sure if the aquantia driver is set up for it.
>> >> > >
>> >> > > This appears to trigger an issue from mvpp2:
>> >> > > mvpp2 f2000000.ethernet eth0: validation of usxgmii with support
>> >> > > 00000000,00018000,000e706f and advertisement
>> >> > > 00000000,00018000,000e706f failed: -EINVAL
>> >> >
>> >> > Ah, I forgot this was a separate phy mode. Disregard this.
>> >> >
>> >> > >>
>> >> > >> >                                 1000baseT/Full
>> >> > >> >                                 10000baseT/Full
>> >> > >> >                                 1000baseKX/Full
>> >> > >> >                                 10000baseKX4/Full
>> >> > >> >                                 10000baseKR/Full
>> >> > >> >                                 2500baseT/Full
>> >> > >> >                                 5000baseT/Full
>> >> > >> >         Supported pause frame use: Symmetric Receive-only
>> >> > >> >         Supports auto-negotiation: Yes
>> >> > >> >         Supported FEC modes: Not reported
>> >> > >> >         Advertised link modes:  10baseT/Half 10baseT/Full
>> >> > >> >                                 100baseT/Half 100baseT/Full
>> >> > >> >                                 1000baseT/Full
>> >> > >> >                                 10000baseT/Full
>> >> > >> >                                 1000baseKX/Full
>> >> > >> >                                 10000baseKX4/Full
>> >> > >> >                                 10000baseKR/Full
>> >> > >> >                                 2500baseT/Full
>> >> > >> >                                 5000baseT/Full
>> >> > >> >         Advertised pause frame use: Symmetric Receive-only
>> >> > >> >         Advertised auto-negotiation: Yes
>> >> > >> >         Advertised FEC modes: Not reported
>> >> > >> >         Link partner advertised link modes:  100baseT/Half 100baseT/Full
>> >> > >> >                                              1000baseT/Half 1000baseT/Full
>> >> > >> >                                              10000baseT/Full
>> >> > >> >                                              2500baseT/Full
>> >> > >> >                                              5000baseT/Full
>> >> > >> >         Link partner advertised pause frame use: No
>> >> > >> >         Link partner advertised auto-negotiation: Yes
>> >> > >> >         Link partner advertised FEC modes: Not reported
>> >> > >> >         Speed: 10000Mb/s
>> >> > >> >         Duplex: Full
>> >> > >> >         Port: Twisted Pair
>> >> > >> >         PHYAD: 8
>> >> > >> >         Transceiver: external
>> >> > >> >         Auto-negotiation: on
>> >> > >> >         MDI-X: Unknown
>> >> > >> >         Link detected: yes
>> >> > >> > # ping 192.168.1.146 -c5
>> >> > >> > PING 192.168.1.146 (192.168.1.146): 56 data bytes
>> >> > >> > 64 bytes from 192.168.1.146: seq=0 ttl=64 time=0.991 ms
>> >> > >> > 64 bytes from 192.168.1.146: seq=1 ttl=64 time=0.267 ms
>> >> > >> > 64 bytes from 192.168.1.146: seq=2 ttl=64 time=0.271 ms
>> >> > >> > 64 bytes from 192.168.1.146: seq=3 ttl=64 time=0.280 ms
>> >> > >> > 64 bytes from 192.168.1.146: seq=4 ttl=64 time=0.271 ms
>> >> > >> >
>> >> > >> > --- 192.168.1.146 ping statistics ---
>> >> > >> > 5 packets transmitted, 5 packets received, 0% packet loss
>> >> > >> > round-trip min/avg/max = 0.267/0.416/0.991 ms
>> >> > >> > # # force switch port to 1G
>> >> > >> > [  193.343494] mvpp2 f2000000.ethernet eth0: phy link down
>> >> > >> > 10gbase-r/Unknown/Unknown/none/off
>> >> > >> > [  193.343539] mvpp2 f2000000.ethernet eth0: mac link down
>> >> > >> > [  193.344524] mvpp2 f2000000.ethernet eth0: Link is Down
>> >> > >> > [  193.351973] aqr107_link_change_notify state=5:nolink an=1 link=0
>> >> > >> > duplex=255 speed=-1 26:10gbase-r
>> >> > >> > [  197.472489] mvpp2 f2000000.ethernet eth0: phy link up /1Gbps/Full/pause/off
>> >> > >>
>> >> > >> Well, it looks like we have selected PHY_INTERFACE_MODE_NA. Can you send
>> >> > >> the value of MDIO_PHYXS_VEND_IF_STATUS (dev 4, reg 0xe812)? Please also
>> >> > >> send the global config registers (dev 0x1e, reg 0x0310 through 0x031f)
>> >> > >> and the vendor provisioning registers (dev 4, reg 0xc440 through
>> >> > >> 0xc449).
>> >> > >
>> >> > > yes, this is what I've been looking at as well. When forced to 1000m
>> >> > > the register shows a phy type of 11 which according to the aqr113
>> >> > > datasheet is XFI 5G:
>> >> > > aqr107_read_status STATUS=0x00001258 (type=11) state=4:running an=1
>> >> > > link=1 duplex=1 speed=1000 interface=0
>> >> >
>> >> > That's pretty strange. Seems like it's rate adapting from 5g instead of
>> >> > 10g. Is SERDES Mode in the Global System Configuration For 1G register
>> >> > set to XFI?
>> >>
>> >> 1E.31C=0x0106:
>> >>   Rate Adaptation Method: 2=Pause Rate Adaptation
>> >>   SERDES Mode: 6=XFI/2 (XFI 5G)
>> >>
>> >
>> > The SERDES mode here is not valid and it seems to always be set to
>> > XFI/2 unless I init/use the AQR113 in U-Boot. If I manually set SERDES
>> > Mode to 0 (XFI) in the driver I find that all rates
>> > 10g,5g,2.5g,1g,100m work fine both in Linux 6.0 and in Linux 6.1-rc5.
>> > I'm still trying to understand why I would need to set SERDES Mode
>> > manually (vs the XFI mode specific firmware setting this) but I am
>> > unclear what the rate adaptation in 6.1 provides in this case. Is it
>> > that perhaps the AQR113 is handling rate adaptation internally and
>> > that's why the non 10gbe rates are working on 6.0?
>>
>> The changes in 6.1 are
>>
>> - We now always enable pause frame reception when doing rate adaptation.
>>   This is necessary for rate adaptation to work, but wasn't done
>>   automatically before.
>> - We advertise lower speed modes which are enabled with rate adaptation,
>>   even if we would not otherwise be able to support them.
>>
>> I'm not sure why you'd have XFI/2 selected in 6.1 if it isn't selected
>> in 6.0.
> 
> Sean,
> 
> Thanks for the explanation. The issue I had which resulted in the
> wrong SERDES mode was simply that I was using the wrong aquantia
> firmware. They customize the firmware to default registers like SERDES
> mode specifically for customers and I was unknowingly using the
> firmware for XFI/2 instead of XFI.
> 
> I suppose it would be worth putting something in the aquantia driver
> that verifies SERDES mode matches the phy-mode from dt to throw an
> error.
> 
> Best Regards,
> 
> Tim

Can you test the following series to see if it fixes your problem:

https://lore.kernel.org/netdev/20221128195409.100873-1-sean.anderson@seco.com/

--Sean
