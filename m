Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C596AC7C8
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCFQXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjCFQXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:23:06 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE763866F;
        Mon,  6 Mar 2023 08:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vo6Y0OQdHfNkP+rpt+LDBypnuGm1HNHuG3DMEbKEMmM=;
 b=UlfTWKx7MUu9N7GMNilWXnnea7caYO/kIWbfJQ3uCddBIxhMsvzZJy+7vdHNgKX5oISTjd4h8AdAW3lYodw58vE/nWs0LY1RIOcRS04pB0sVDC8qFNyFOmamzxwIoyFz7C9Sy9kTjcsTbDmBMAW9GwDfKGvFNT7Ew3SskCfM6At8/YvVTi2ktAMGumhm87g6LClHA0k6kwlnlc+IlsYIWIwukn3v+4SulLtT3VW8edNTQSO1GeeP1Mi+XKp73jj6RxvUc/HMnGDEvU89QobpO7mA6xy1BzYNEvPSdeScRuXs25xGRM7JlwqzU92L2tti2uHd2H0ls86ADIfR+zDB4A==
Received: from AM6P194CA0029.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::42)
 by PA4PR03MB7198.eurprd03.prod.outlook.com (2603:10a6:102:107::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Mon, 6 Mar
 2023 16:13:31 +0000
Received: from AM6EUR05FT050.eop-eur05.prod.protection.outlook.com
 (2603:10a6:209:90:cafe::1a) by AM6P194CA0029.outlook.office365.com
 (2603:10a6:209:90::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Mon, 6 Mar 2023 16:13:31 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 20.160.56.81)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Fail (protection.outlook.com: domain of seco.com does not
 designate 20.160.56.81 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.81; helo=inpost-eu.tmcas.trendmicro.com;
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.81) by
 AM6EUR05FT050.mail.protection.outlook.com (10.233.241.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.15 via Frontend Transport; Mon, 6 Mar 2023 16:13:31 +0000
Received: from outmta (unknown [192.168.82.140])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id E934E2008088D;
        Mon,  6 Mar 2023 16:13:30 +0000 (UTC)
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (unknown [104.47.11.49])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 5DA5D2008006F;
        Mon,  6 Mar 2023 16:11:50 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BkWS2Gf2/4L7wniKTVMAoDSIncZxuwMkqQHa3wE7n0ho2IV8RzQPXNfTDLCx+LCsyTz3/wjgz/i/DrtPs3TcMtR0RwPQ7+P/CKwe3v9/R1rwBBqbzD946itiSvi/baOtMCcEExFZViX5TLm78KdgZaJunbdXe1yfYRP9BR1O0WX+4dTqE9HOxEQyjSt2PDoPpCFEnFwevxB9c2GuWDNbS5Yp+cKtnoFbiWO6BMzEG8M8VN7jxdt63gOH3Jw1bA/jv7vdPZhiewhrjxwa/ecOmP+QVUZwEC9Vh6gmzVcYLCa4BruV9kBB6qL/7+/C6JuX3nUJmBsA1bQAryfgLlXyxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vo6Y0OQdHfNkP+rpt+LDBypnuGm1HNHuG3DMEbKEMmM=;
 b=dkP+5k1eTSF/JXwiyOTr7vD8dHRwBiBTRxM+v48yy2/B61KS/EGn4B6gNAjBOFVbrlzot2K7Kq5GAdwrBmg7c/ngBWEzKze1mNQRZpV4Zk0QUqiyvt2UxLLwmQPPwdfjBb0Ag+0dyBA438IZA7CjvS2qvy6pKcBwpsivpH1gmF2oGsOtJDvtQ0uhlAI1OJBFynerpiYfI3S2wUJg7EX9cxBoqWtLlCZo61ykSup3H7Ob2pfncLUW7/mBEqIf1jIp0JcXk+ErgRUsbkOuI0UxWY6DzcEnabC2t3KF6brlPru8NwISzb2tc6ccxOBGGZl2yVti5r7YgJc7vCZe9jPQ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vo6Y0OQdHfNkP+rpt+LDBypnuGm1HNHuG3DMEbKEMmM=;
 b=UlfTWKx7MUu9N7GMNilWXnnea7caYO/kIWbfJQ3uCddBIxhMsvzZJy+7vdHNgKX5oISTjd4h8AdAW3lYodw58vE/nWs0LY1RIOcRS04pB0sVDC8qFNyFOmamzxwIoyFz7C9Sy9kTjcsTbDmBMAW9GwDfKGvFNT7Ew3SskCfM6At8/YvVTi2ktAMGumhm87g6LClHA0k6kwlnlc+IlsYIWIwukn3v+4SulLtT3VW8edNTQSO1GeeP1Mi+XKp73jj6RxvUc/HMnGDEvU89QobpO7mA6xy1BzYNEvPSdeScRuXs25xGRM7JlwqzU92L2tti2uHd2H0ls86ADIfR+zDB4A==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PR3PR03MB6426.eurprd03.prod.outlook.com (2603:10a6:102:7a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 16:13:22 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%5]) with mapi id 15.20.6156.027; Mon, 6 Mar 2023
 16:13:22 +0000
Message-ID: <4cf5fd5b-cf89-4968-d2ff-f828ca51dd31@seco.com>
Date:   Mon, 6 Mar 2023 11:13:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net v2] net: dpaa2-mac: Get serdes only for backplane
 links
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
References: <20230304003159.1389573-1-sean.anderson@seco.com>
 <20230306080953.3wbprojol4gs5bel@LXL00007.wbi.nxp.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230306080953.3wbprojol4gs5bel@LXL00007.wbi.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR1501CA0028.namprd15.prod.outlook.com
 (2603:10b6:207:17::41) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PR3PR03MB6426:EE_|AM6EUR05FT050:EE_|PA4PR03MB7198:EE_
X-MS-Office365-Filtering-Correlation-Id: 224a8b2d-0de3-476f-ead7-08db1e5dba81
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: ZOXHDNYoM0t4iHX4I7CHC79ceshPgRjP6UbjZhK3fWKUAMH2Vg/ng5W+7C9wIZGuWKRkwhAsMZEZ3y6gn/b+B6KzeMWBt4wE6UPYPb7RYk9+oeQ5XjEb4CPv06nFqQhtWVzlODKA3jg2sDDhcMUjmNxkUdil3OQpIvDde/0T6QG5hwnp4VCAPv8sLoc61nKcDhZ5YAd1EBwhO37k4uAEP2f2s7XRnikSb27afARwgBAVEYoH+m43r0mu142GoaM0phrjkx0jkODrgxxZihdiIIaLk6fmdTtOXdtcEVHW+AeLoylQeeVt79EO3Ku4go7MrbQoKeYoONmIGJF7RNJ1A5K6YrNzpB4wvwUph5knlm1MnEU16+Kyuf1DFe6b+j5mnVRGGT06105nbuxMAXUUKSw7Jyr9mBdDmncVQEYYwDTSUHPLy5x8DTZXi77gUEXPauJd/fEWWNgTH12FrhpZO1uJ3BTOY3ewzcHSDYY0XT/qLVcKdudqfBLUF/2lcBPqQ7LxGMxkcWM4eiDHtoD72uIAuiHgs9SprW/8+zzmY3EJHyXaazlt7DGQBR2dIm9/GVVdqHYbYCqC4VDQxF6ZBUp+dSgBWOfoC/oXjIkUC1plknaDs6w137I6K52v+moEaLQYZ1ysSyx00YsnkhyJI9xM3YqgnsKaLWMF5rd0iCIX4sj5YsZ/i8arB4NxBvz4DJ2ZuXZwa4qDjpikkoAU7kPHFZXJpnIp4RyFHrg9LgJlw+rIzr7drVbK1vsJ2L3J
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(346002)(39850400004)(366004)(376002)(451199018)(6506007)(53546011)(966005)(6486002)(6666004)(36756003)(83380400001)(86362001)(31696002)(38100700002)(38350700002)(6512007)(186003)(26005)(2616005)(41300700001)(66946007)(66556008)(4326008)(8676002)(6916009)(2906002)(66476007)(8936002)(31686004)(44832011)(5660300002)(52116002)(316002)(54906003)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6426
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM6EUR05FT050.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 7fe553ae-f5fd-422e-a64e-08db1e5db519
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JyO+L00fKWM8h5p6LSvf49e8/MIzWMDTFiaIdDSqibcjzGNab8Se1175BXALSTIiG8dJ9pyUrU7gksZGfOic0FgbXFduihWzXp4HYktJwPnXAfS9e4Pq+duFt2JvmM7NjJxe1kwP7FRftTHy1IkuVY3qsQrAFzfO+LBbFkfu71PvR55ruQNx4ijseor+T+9LFDGGpmzRHtvST7Tng2APCfUCN6YOhdc53BA3+3ogPObOwnpk3oxB221QXYen/jAY3VLHmyAFtiQEQaf3kXVyj544Iuj1BemMPCo9avqTJyfJPX3buxn8/fCaiST2yFzRGLFi03eIdaMECmJT5+JnNPOG7un+vHOGG0ribau8K+jJ74JTraCLi/Qtu9unyYzhxZPxSRnbn47UqtTBau5/U9xDtw0ROV4fsNr4LxRHEWktEnqf2eAgnNHjpa5kBsuMdRhjFeKWjT9gpvGyKiNEDpcX+JO+ZKNHYZVng8lDglii7b2AFlHbgRraIRouCuPT++jIenG6lhh35nTT/kUBPt224zUtnRixIWbuNON0P24hkniYEJJi10AK7MkJ6wvoy4JwWH8AkXssW/Ul/RItrcAuQHHcPXkDhrH/mqb7EOWoSaptd5/qvdBGLtG4TJeUKSF2jpMw6Moyvmgs3N+MzuzYPchpeJBudN7f/zrXGzr2pAgcIPlf3e5CKkdaPxwl3YmabDbGIE0I/yzAHdinsJ6AeUzKCm5iZUwta3IO4ArnIxSzNr9GfoaMq1HRXxiIWveoDduOVgafWlAJtGFL7A6mQZYuAf+Ncvn3726Q9Jg=
X-Forefront-Antispam-Report: CIP:20.160.56.81;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(346002)(39850400004)(451199018)(40470700004)(36840700001)(46966006)(31686004)(5660300002)(8936002)(44832011)(70586007)(2906002)(70206006)(6916009)(4326008)(8676002)(54906003)(316002)(478600001)(47076005)(34020700004)(36756003)(36860700001)(6666004)(6486002)(6506007)(6512007)(966005)(53546011)(26005)(2616005)(41300700001)(40480700001)(82740400003)(31696002)(86362001)(7596003)(82310400005)(83380400001)(356005)(40460700003)(336012)(186003)(7636003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 16:13:31.2612
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 224a8b2d-0de3-476f-ead7-08db1e5dba81
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.81];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT050.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7198
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/6/23 03:09, Ioana Ciornei wrote:
> On Fri, Mar 03, 2023 at 07:31:59PM -0500, Sean Anderson wrote:
>> When commenting on what would become commit 085f1776fa03 ("net: dpaa2-mac:
>> add backplane link mode support"), Ioana Ciornei said [1]:
>> 
>> > ...DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
>> > by Linux (since the firmware is not touching these). That being said,
>> > DPMACs in TYPE_PHY (the type that is already supported in dpaa2-mac) can
>> > also have their PCS managed by Linux (no interraction from the
>> > firmware's part with the PCS, just the SerDes).
>> 
>> This implies that Linux only manages the SerDes when the link type is
>> backplane. Modify the condition in dpaa2_mac_connect to reflect this,
>> moving the existing conditions to more appropriate places.
> 
> I am not sure I understand why are you moving the conditions to
> different places. Could you please explain?

This is not (just) a movement of conditions, but a changing of what they
apply to.

There are two things which this patch changes: whether we manage the phy
and whether we say we support alternate interfaces. According to your
comment above (and roughly in-line with my testing), Linux manages the
phy *exactly* when the link type is BACKPLANE. In all other cases, the
firmware manages the phy. Similarly, alternate interfaces are supported
*exactly* when the firmware supports PROTOCOL_CHANGE. However, currently
the conditions do not match this.

> Why not just append the existing condition from dpaa2_mac_connect() with
> "mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE"?
> 
> This way, the serdes_phy is populated only if all the conditions pass
> and you don't have to scatter them all around the driver.

If we have link type BACKPLANE, Linux manages the phy, even if the
firmware doesn't support changing the interface. Therefore, we need to
grab the phy, but not fill in alternate interfaces.

This does not scatter the conditions, but instead moves them to exactly
where they are needed. Currently, they are in the wrong places.

--Sean

>> 
>> [1] https://lore.kernel.org/netdev/20210120221900.i6esmk6uadgqpdtu@skbuf/
>> 
>> Fixes: f978fe85b8d1 ("dpaa2-mac: configure the SerDes phy on a protocol change")
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> For v2 I tested a variety of setups to try and determine what the
>> behavior is. I evaluated the following branches on a variety of commits
>> on an LS1088ARDB:
>> 
>> - net/master
>> - this commit alone
>> - my lynx10g series [1] alone
>> - both of the above together
>> 
>> I also switched between MC firmware 10.30 (no protocol change support)
>> and 10.34 (with protocol change support), and I tried MAC link types of
>> of FIXED, PHY, and BACKPLANE. After loading the MC firmware, DPC,
>> kernel, and dtb, I booted up and ran
>> 
>> $ ls-addni dpmac.1
>> 
>> I had a 10G fiber SFP module plugged in and connected on the other end
>> to my computer.
>> 
>> My results are as follows:
>> 
>> - When the link type is FIXED, all configurations work.
>> - PHY and BACKPLANE do not work on net/master.
>> - I occasionally saw an ENOTSUPP error from dpmac_set_protocol with MC
>>   version 10.30. I am not sure what the cause of this is, as I was
>>   unable to reproduce it reliably.
>> - Occasionally, the link did not come up with my lynx10g series without
>>   this commit. Like the above issue, this would persist across reboots,
>>   but switching to another configuration and back would often fix this
>>   issue.
>> 
>> Unfortunately, I was unable to pinpoint any "smoking gun" due to
>> difficulty in reproducing errors.  However, I still think this commit is
>> correct, and should be applied. If Linux and the MC are out of sync,
>> most of the time things will work correctly but occasionally they won't.
>> 
>> [1] https://lore.kernel.org/linux-arm-kernel/20221230000139.2846763-1-sean.anderson@seco.com/
>>     But with some additional changes for v10.
>> 
>> Changes in v2:
>> - Fix incorrect condition in dpaa2_mac_set_supported_interfaces
>> 
>>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 16 ++++++++++------
>>  1 file changed, 10 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
>> index c886f33f8c6f..9b40c862d807 100644
>> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
>> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
>> @@ -179,9 +179,13 @@ static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
>>  	if (err)
>>  		netdev_err(mac->net_dev,  "dpmac_set_protocol() = %d\n", err);
>>  
>> -	err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET, state->interface);
>> -	if (err)
>> -		netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n", err);
>> +	if (!phy_interface_mode_is_rgmii(mode)) {
>> +		err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET,
>> +				       state->interface);
>> +		if (err)
>> +			netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n",
>> +				   err);
>> +	}
>>  }
>>  
>>  static void dpaa2_mac_link_up(struct phylink_config *config,
>> @@ -317,7 +321,8 @@ static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
>>  		}
>>  	}
>>  
>> -	if (!mac->serdes_phy)
>> +	if (!(mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE) ||
>> +	    !mac->serdes_phy)
>>  		return;
> 
> For example, you removed the check against
> DPAA2_MAC_FEATURE_PROTOCOL_CHANGE from below in dpaa2_mac_connect() just
> to put it here.
> 
>>  
>>  	/* In case we have access to the SerDes phy/lane, then ask the SerDes
>> @@ -377,8 +382,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>>  		return -EINVAL;
>>  	mac->if_mode = err;
>>  
>> -	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
>> -	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
>> +	if (mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE &&
>>  	    is_of_node(dpmac_node)) {
>>  		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);
>>  
>> -- 
