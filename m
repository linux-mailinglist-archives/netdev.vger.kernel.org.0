Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6CF26301D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 17:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbgIIMTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 08:19:49 -0400
Received: from mail-am6eur05on2128.outbound.protection.outlook.com ([40.107.22.128]:17132
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729992AbgIIMSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 08:18:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pivjlr6bCNfLCShB+we5Qk/7hVqW6zXdPpEWsjiM1zFMHKN97RalCtFzgoRNfVrDvvEKc7Mxwa9RI1kHunOA/XcUvvr9ZpHN75kdMippkDz7dmg4ju5VTJHn7XSebQmER3sc5aNzX3eRKHTnPC+ix6oLWIlZ6uEaMzYyS0K/XCYkuKUdJ8n0XCTR4gZ+IpUaG/x/chCxQJqzjE1aBIBCXFOufC8GF7tm5BV9EOO7RjaFSnAMyRCKvTU0G5wcht9Di0c5HXW6U7dB3DtGe4fv6eaT7kniVQy2VP2VcSQ5qoN54RIz/I/qC+k0n3HetNK0d6UDw5F4RjXugyj1GCtx2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcgzFqwj0qSokQf3n8XTWalbgOd1NPmpmotUkV5Dt0g=;
 b=X5gmU/eplCuMxKohUdRAxSgHT+chlmWoirjZbJ2dSabWJTyPZKK3My+n3e0EFdINKusp15PcIu1HO939VKlXEWRJMr/PHw8sAo9Ipqs+rJJrj6oYcRVHIQOSOxtJ7IuwwnvP7VMSnKIuZnml035RT8SZiM2g5Q1bHP2pV6DKZbbb+w44qV3reZWjqLd/+FVR/vBbwnTDi+EUiMgk19Nv66c/jdP1SAqz8wWohgorEedMiG3y1NWiF6F45Hg10c2hKBZPFf6U+aMThvdceIdT3QLmQfupXYS4WhzCL0ZYw+iRUFwTUdbP6aa4TNeJXa1hQjunKESwsMzTbb6R3MGJcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcgzFqwj0qSokQf3n8XTWalbgOd1NPmpmotUkV5Dt0g=;
 b=IGJwNKBut+AHcRsDFeN8OK55US4CLkrGXmtQ2di/dOxjfQN3yLs+M5JTv9Az0C+0cKV1gkVayvcwkX1dVltmkO1+ISFIquMlgLyfJmP7oriCgIRKi4YGgtRZ8VtPNu4XtmaAp8FBVeS/wkUoRvu7+0beiOq1/CrYZwLYuur/D1o=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0123.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c5::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Wed, 9 Sep 2020 12:02:15 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Wed, 9 Sep 2020
 12:02:15 +0000
Date:   Wed, 9 Sep 2020 15:02:07 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Alex Elder <elder@linaro.org>
Cc:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFT net] net: ipa: fix u32_replace_bits by u32p_xxx version
Message-ID: <20200909120207.GA20411@plvision.eu>
References: <20200908143237.8816-1-vadym.kochan@plvision.eu>
 <030185d3-8401-dd2f-8981-9dfe2239866a@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <030185d3-8401-dd2f-8981-9dfe2239866a@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR0202CA0050.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::27) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR0202CA0050.eurprd02.prod.outlook.com (2603:10a6:20b:3a::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 12:02:14 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30a4cff7-c189-4b0a-1b82-08d854b8314c
X-MS-TrafficTypeDiagnostic: HE1P190MB0123:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0123A4D88F38076DC2808AFD95260@HE1P190MB0123.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rvZ6WXDVQQmeTKIv3HG0vvEvlg/1FZ2jrc5K3MQ2N+02ltv2d2MET9UYGmXZjKCJMUDPC7bMErUbQ58FUiAyuwpE+wlAwPBpYqN44/1jNs0NFvA7V4f5UmpaNFeZlxhgqYIPaEAvzIL2h7+nVhUMu6kdAbLurPJwofyUPF0u+XRYKt7DWrUbOlErmRV6fxjEshkEOlJ4+z6ELbAOEHFsxam7KrH488WPIh8FzKUE1prs98nI1n8kKqU13mfI/UGI1/YDSZDY+ELQmt/aWD+HYH2++KnGjsYC+qCGPVWqEb0AA8f1UBuvK4/i8dg3KAgW968NnL/d/sT1gMV3Q9ReJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39830400003)(52116002)(8676002)(1076003)(7696005)(2906002)(66574015)(55016002)(83380400001)(36756003)(54906003)(53546011)(316002)(44832011)(4326008)(66476007)(86362001)(66556008)(66946007)(16526019)(478600001)(26005)(8886007)(2616005)(956004)(8936002)(33656002)(5660300002)(6666004)(186003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: uVFqXAgHQiOky0bxGbBPXObj8fe2HdCcSe5gSmVFfeOgCihmqIpd/kX5C6obdxSXCv6tvdS9jxZ/NKN5gqpEblw5gW/0E8gSO/RVRsMxm8SmIBtgYLl6LJmoXlLN00Oo3oPWT2J8pOGhzcr5fB/MbBuVA3eGgn5PJewjOTViXXzbDBMcJ45tC9K4SPOPspM6gYWSARW1NO1I/41ZgnXa+niPsiPNGjWVKEaM10bpHHj/FhuW4mZlClWuUtvWeG5lhr0ztFy+wtVrVEDuheJO09Tc1G+Cg2WQqjNwItB7Z8TMlNM9BLIRhqBuNFrLmmmHzgbPAkukxpY30o57KYs24OnyWu2/vnQnAFvu3gPoHfRDMWM3YtPzo+07J54WZ/DyvxT/6tlsJPagnHSuo4BvWYgqmPOUOssRTvTfZGAKQQMOgcj7MpoQRChaC0sOyqES/or16QuiUSAC3oYs/Uf5gF5R1sDNvDEN8/3z+7+1ATscPmhfQY1MUpaDRaRwm3vhqd3U1meWLPtKfi/ibNi0JIL56olTnfbjODw3r+LjhXlE8brkWqZAgi7x54nsu63kcGCT5bPZmnrlv7KoMHCAW0i+MASo0QOh/dUurGzvXx9ds3jFMZInZWrQwFqNctARRQJp76UcFecqdfX1u3TO9w==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a4cff7-c189-4b0a-1b82-08d854b8314c
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 12:02:15.5089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nlelJf5p9ZW07J9Uf6TAI7J1/qPJJYwDF++2eV4qkl8iP+Hfa0B5BJQxZNyUH55Sqae91fhho2c5EgUylsxHIx/gInwIvQocKbR+f/p+fOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0123
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

On Wed, Sep 09, 2020 at 06:53:17AM -0500, Alex Elder wrote:
> On 9/8/20 9:32 AM, Vadym Kochan wrote:
> > Looks like u32p_replace_bits() should be used instead of
> > u32_replace_bits() which does not modifies the value but returns the
> > modified version.
> > 
> > Fixes: 2b9feef2b6c2 ("soc: qcom: ipa: filter and routing tables")
> > Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> 
> You are correct!  Thank you for finding this.
> 
> Your fix is good, and I have now tested it and verified it
> works as desired.
> 
> FYI, this is currently used only for the SDM845 platform.  It turns
> out the register values (route and filter hash config) that are read
> and intended to be updated always have value 0, so (fortunately) your
> change has no effect there.
> 

I had such assumption that probably it works without the fix.

> Nevertheless, you have fixed this bug and I appreciate it.
> 
> Reviewed-by: Alex Elder <elder@linaro.org>
> 

My understanding is that I need to re-submit this as an official patch
without RFT/RFC prefix and with your reviewed tag ?

Regards,
Vadym Kochan

> > ---
> > Found it while grepping of u32_replace_bits() usage and
> > replaced it w/o testing.
> > 
> >  drivers/net/ipa/ipa_table.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
> > index 2098ca2f2c90..b3790aa952a1 100644
> > --- a/drivers/net/ipa/ipa_table.c
> > +++ b/drivers/net/ipa/ipa_table.c
> > @@ -521,7 +521,7 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
> >  	val = ioread32(endpoint->ipa->reg_virt + offset);
> >  
> >  	/* Zero all filter-related fields, preserving the rest */
> > -	u32_replace_bits(val, 0, IPA_REG_ENDP_FILTER_HASH_MSK_ALL);
> > +	u32p_replace_bits(&val, 0, IPA_REG_ENDP_FILTER_HASH_MSK_ALL);
> >  
> >  	iowrite32(val, endpoint->ipa->reg_virt + offset);
> >  }
> > @@ -573,7 +573,7 @@ static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
> >  	val = ioread32(ipa->reg_virt + offset);
> >  
> >  	/* Zero all route-related fields, preserving the rest */
> > -	u32_replace_bits(val, 0, IPA_REG_ENDP_ROUTER_HASH_MSK_ALL);
> > +	u32p_replace_bits(&val, 0, IPA_REG_ENDP_ROUTER_HASH_MSK_ALL);
> >  
> >  	iowrite32(val, ipa->reg_virt + offset);
> >  }
> > 
> 
