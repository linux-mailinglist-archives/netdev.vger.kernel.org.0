Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482CF38A888
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 12:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237687AbhETKvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 06:51:19 -0400
Received: from mail-eopbgr130090.outbound.protection.outlook.com ([40.107.13.90]:50308
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238545AbhETKtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 06:49:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Us4HNIq13Y/xHLy77bZmtxWVIKvXRtaAa0ShxbUcMD55/tDesny8D0Ys03pVrxxzhEdMYJhbyH8FOiF3ZIEfvN6JHDo83PJB6TyWlBY0rC470A5FxUdqctn7sfAsqnuvDKvWG1mhvUFWsLpxwaXug0LgdUA4ptG+dihSJHhC6vyz8R3qXOF/1FScX9TYnFv/FbHDNnMDazzsU7ubGJGMX0leQ9/5JsVD4Yhd+t0JTi1RDW3j5bLn5u/kFtxYVQ5LabtomMD5kY9v7OHiudRLi8fITObXILu66YXZmCUEaEFHl2NtwM2ko5m4hLClappMFZyutWl0Ejyj8Hm/QOOb6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dk8YWKxxANO6zjBxiyn8/RlX2TNVioWCTsWOxYdQDsg=;
 b=R2jEOsuSbVS5PWHiMTBFZqxVzAxNz9KiYRrnodRZPnoM+Qpy2vhlHXPpfW3YP9TzeMglv51SWwIvyiq6iGOWlnrxt0UlTw9I8DMSLLN0GsHeEFXKF/NxHcSLSSpdSJT1YmVyg54drBsw2E+yrwODvImvWU8CSgzhrr9PPTJ1Oz7M84sGlSEpi08l3atHa8zpMp1vhm3Wx2lnNgLY4uE9C3n3+l2K2pj91aRRhzitdpDuxuh9WrKL52SUuOgNPpmfNijnVymh/7TUBBNsHXx9luPKjAlmM03odyorI1Lwx++A/KFgRC5qbkeW3bDbqNMQHHmJuGQYq1g/yRodw7uDcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dk8YWKxxANO6zjBxiyn8/RlX2TNVioWCTsWOxYdQDsg=;
 b=qXO45MOMBRB6d+PLDKwWCgTucec9gP8cyrFnnNJjdldLLHtRDyqJ7kSLnXZ6k/4e2GEHgboFLoogLKTj6eat0f6f2t+Y+wv4XM7EHPs8o+f6LPVgz2/pyuC9XWOQnfUR6DV0cfW4rI5WRG/j73Xgh+hIly7/NASJc0W4LY3F5XY=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0026.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c9::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Thu, 20 May 2021 10:48:17 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 10:48:17 +0000
Date:   Thu, 20 May 2021 13:48:14 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [RFC net-next 1/4] net: marvell: prestera: try to load previous
 fw version
Message-ID: <20210520104814.GA5302@plvision.eu>
References: <20210519143321.849-1-vadym.kochan@plvision.eu>
 <20210519143321.849-2-vadym.kochan@plvision.eu>
 <YKW3YhuDSHQtR4Tb@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKW3YhuDSHQtR4Tb@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR03CA0073.eurprd03.prod.outlook.com
 (2603:10a6:208:69::14) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM0PR03CA0073.eurprd03.prod.outlook.com (2603:10a6:208:69::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 10:48:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a2c337d-8987-4cea-40d7-08d91b7cc658
X-MS-TrafficTypeDiagnostic: HE1P190MB0026:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0026B181D3F5F78B2C124715952A9@HE1P190MB0026.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XPn/xQIzcXIdqwhOunO3BLoNsm0T+IG7rQ4upPPzlg3egbRzBwRrxRWN8gAT2p3Ou/YJMShLxb1b2MKbpzd3Ljub3HQ3ZxbWDJ3NRsVU4Rb1BkK4YLNxRweMVZFxI8Zs9w77ss8ql+Y81iRe4rVYogeoup8TF7BxYmY85Anif4IOY/7HHTVafwrSCyW2Zml7jRDfpNEkQYJw6SC7fe8DLblHCigO1E/bLbvWP0HYcnl9Fmt3BcKgQ1Ti6Xrb27/JYokUTI5y2vKlTs4xf/VXTsItSvSNLF9KFMq4+N28FvhuOymurisDaJbtE2lN7mVuAypBMSvZBXAt+RofccP+/4MsfBbnhgDreFU8oayl0QCYhAPqX0m8Fo/Uy0Y4V6217ctetOlynOMJ0+83yLw9l+onKPwPmQNEuNC3C17Dj9o2Wq9jGJ2rx5jHWgasHS4ajTm65Fa6zHdT64L7Tpmkd80D7n4gtkgmwtXqRZ3msUoysjLb1jkeEaWMHL6uqB5OJRPz+PbR2ZQwA3ZtlzvWozdvmfIo+Vv8kDrI85N7nsDfELlZwg3t5QfueLixXBl+8zHpY0XQaMwTyZW6gYWa0ZTz3x7j0KTln9gBu4drkDTYxLvAU7A2ow8vdiozq3D2y26TMelToY3R56mpYs1Tmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(376002)(136003)(366004)(346002)(396003)(316002)(54906003)(26005)(8886007)(66946007)(478600001)(1076003)(83380400001)(33656002)(66476007)(44832011)(4326008)(6916009)(8936002)(956004)(2616005)(38350700002)(66556008)(86362001)(2906002)(8676002)(36756003)(7696005)(186003)(52116002)(38100700002)(5660300002)(16526019)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jVpWmSc1/M4WHJNaSngiqopjKOn7IZEvxz2Q6oiKiCBRkZFPN7Y9wLeHTbGd?=
 =?us-ascii?Q?a9t3APGJoQDgoyALqdzMrzn5XBw2IfQhTT2aMxj8hkJi5hIXxk4QZTs//6UA?=
 =?us-ascii?Q?ywVqD+/AwgqGfOWZXv6sCD+paQq1k/VWedlV9K17OWjxqir6b3qG1Sj3MItk?=
 =?us-ascii?Q?FoEcbVeN6tE6cseHaHBfq2BoU4IQGWp2rVI8MFnfCMeiUK6milp4egGWJSwl?=
 =?us-ascii?Q?UHilw16cEQ24+wIXbOuLaLslDNmgCPHUGlnTY6r0Q7rUG7xs54UyMqzH9bxe?=
 =?us-ascii?Q?WnX2D/gUpcyOwpWDGjwy6p3UhPKIHoEGCvgj/SpzOKfbzwat3VrD2sOc6uhK?=
 =?us-ascii?Q?Id5icMln075hKwpklkSRID/0MAB6Ki2d7UNA1hEDbfwUUl9IGj7ebhzIUC+K?=
 =?us-ascii?Q?wpcSfrqoezR+CmE4q7HjqNq0phGJZfaYa/1iEmKO/+8U2UpolUlAY6kMRdx8?=
 =?us-ascii?Q?hpmFNdfC1F13zKIZvG/BJnIifwSCTj49uhWOKkdJXXg/Ey/Z9uhZJTiZC3Px?=
 =?us-ascii?Q?+9fJpvdORoDkEpggskOlW92MlPeZPInsF0x0ycRAhSX4sp5icISMsmSlIhOZ?=
 =?us-ascii?Q?Gro/UnCeNmELd8S+VKTnHOdElviwTmOEGjyIgkr8IG7riTnYg1q8g4ZWzg5C?=
 =?us-ascii?Q?4aa3YWedynp0x/aZ94V8K3H65YHaX9x1B9f3noldiZvbvZ5Wj6W6BRnBBs87?=
 =?us-ascii?Q?cq7Mvr8HdLlryHJpGtoYKTOf6qC4LjWytdDfcz+r2Sfzxsct37iTVn863aJy?=
 =?us-ascii?Q?ALyuXV66CaMbXEq0lieF7tMujosCk9+DVtYJTtAJUiqxdPp8BHHILq9eu55z?=
 =?us-ascii?Q?ZMX3TLGu/C8ZSmef8QWXrTBc+GsqizOvpnlf1fckOYHoFS4o0Cls+tr8Juq3?=
 =?us-ascii?Q?u16Fvgn8q318DcZhIjM8rdFCGLWxBWX5EzfX8RSAa8W4GS7ECxJ61VsdpP6x?=
 =?us-ascii?Q?WQLZLBqeJLl4uQglTBMAgaC77qhSig2zAtQ5zxaTT7gYrT5JtcqcK61fGL+o?=
 =?us-ascii?Q?SKB2XMiJB3tHmagjfKKacgLT8ng0z7inAiHx4TJ7F5iMG6XwH9b55MG7NfRA?=
 =?us-ascii?Q?gtf46aiHiitAWl+i8yZYL52O4qdb7y/2Crj3b1unFEfX3IA2I0cXDdaJ8mEe?=
 =?us-ascii?Q?TcUkoGuhdNxDf10JLz8aMr54LEvXH0EtdYrJrS7sTtgfAYq4L+Cr/kRMjJqJ?=
 =?us-ascii?Q?13jVAE+RTGpqzl7Kx4OotIq1f/9lsaBQA1jBHznzIAkUBrdfM/J3l/GSszly?=
 =?us-ascii?Q?B1rq0dKtvWO6Ce3uiK5uLAe+hTqsWI7A1l89gZa6/86zYaX2C+f1RaecVmhT?=
 =?us-ascii?Q?ZjXyiucyInx0bIBXIlQuqj4L?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a2c337d-8987-4cea-40d7-08d91b7cc658
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 10:48:17.1120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LTZD/nAITZ9WlZx1dIr+agtfpiXLiRzzL8EkVS38t47Hb7lWRI4OrW5na+bBNd09ZJaCnpu7ptcnPFGvwBtPeOUUQ2/GQPmn9cq18jGh2P4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0026
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 03:12:02AM +0200, Andrew Lunn wrote:
> > +static int prestera_fw_get(struct prestera_fw *fw)
> > +{
> > +	int ver_maj = PRESTERA_SUPP_FW_MAJ_VER;
> > +	int ver_min = PRESTERA_SUPP_FW_MIN_VER;
> > +	char fw_path[128];
> > +	int err;
> > +
> > +pick_fw_ver:
> > +	snprintf(fw_path, sizeof(fw_path), PRESTERA_FW_PATH_FMT,
> > +		 ver_maj, ver_min);
> > +
> > +	err = request_firmware_direct(&fw->bin, fw_path, fw->dev.dev);
> > +	if (err) {
> > +		if (ver_maj == PRESTERA_SUPP_FW_MAJ_VER) {
> > +			ver_maj--;
> > +			goto pick_fw_ver;
> > +		} else {
> > +			dev_err(fw->dev.dev, "failed to request firmware file\n");
> > +			return err;
> > +		}
> > +	}
> 
> So lets say for the sake of the argument, you have version 3.0 and
> 2.42. It looks like this code will first try to load version 3.0. If
> that fails, ver_maj is decremented, so it tries 2.0, which also fails
> because it should be looking for 2.42. I don't think this decrement is
> a good idea.

Ahh, you are correct, I was too focused on a major version. So the only
option which I see is to hard-code also the previous version.

> 
> Also:
> 
> > +			dev_err(fw->dev.dev, "failed to request firmware file\n");
> 
> It would be useful to say what version you are actually looking for,
> so the user can go find the correct firmware.

I agree.

> 
>    Andrew

Thanks,
