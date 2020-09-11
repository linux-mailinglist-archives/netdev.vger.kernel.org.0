Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A4426682D
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 20:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgIKST0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 14:19:26 -0400
Received: from mail-eopbgr70133.outbound.protection.outlook.com ([40.107.7.133]:15591
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725730AbgIKSTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 14:19:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNwDeB/J8D3/X96R3ZbPFpYOwDCizxJ1aeQsjKB68E3kP702fL+lAzsSRz80FuUQXCNGlMsoCxcGlrGpkjPKx7UrBEFPtll3gRTLl0PwmyZpNGbqEHKhowp/08TE2C6MHUi6pbmnZUpPsWJ7Lp8lDXmuGqMJholZLZyA44hFq0QflkV8FEnrTgnI1yhwfGrof86SCK03px+rxFivgY6AvbtE7obG4AlHdFI+/ZcpsEan6S2+dXfiK03IpYWD0LcbhdatDPXf84oDOm057B2R1PoBnvgLyyvaYqeaZWyJLeJDc1xonQywcTEe6cKV9P8kzC/x361kA4igaeX8PMPQ2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLPSDsdFcGfrFpwyZTl6jaDSfvkyZAeHeZCNBolP1Oc=;
 b=Reik6Ed8m+iim5pnPbuwGV65oNjMRyOV+JqNXvYfrSWExZo57oYtTN8gVSY9bL8Hyot0JXesS2m0ZVt8sHijaKtRiZ6B2tfBgAXUr/6z/fjaAvvOq97hbWET5Rfq+ZfTbGvm8r1ogyHhRWxoKI0GVWtfS1mwLyBO26LcV8JXOhlvgqezB8wcgUEi94V7nmHtmKnZwrl2lrFP9n/Yxca6TKkS1ty1j70s/4a9u/ufa8p6XGAO1iS1PTd/YCAHSrRHmY3JWpMxIgLgbzQOttbXnM30djDXBPIlyl6zZdkZXvkneIkDXqLxsHxG/9mVbbcO0tWRDqdOr+4k868m68TcqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLPSDsdFcGfrFpwyZTl6jaDSfvkyZAeHeZCNBolP1Oc=;
 b=Qm7/Ow9gDsDbrQfrXKCzL6dw0U5sWiNoq/eBT53WwymzCe4f55+NZ/iKyNE1FTvWNS7qEWFzKYbUiTjopwOaCmOQqgco5IXEugeEixb2a8aLfn0j8U2SaKqj8oW4EPpy+VfN5pRhqnUQMBsrk2b8qce45/i7xYZeqOsdLEF8HgY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0363.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:55::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Fri, 11 Sep 2020 18:19:17 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 18:19:17 +0000
Date:   Fri, 11 Sep 2020 21:19:14 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [DISCUSS] sfp: sfp controller concept
Message-ID: <20200911181914.GB20711@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6PR08CA0002.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::14) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6PR08CA0002.eurprd08.prod.outlook.com (2603:10a6:20b:b2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Fri, 11 Sep 2020 18:19:17 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3191886-1719-46ce-b299-08d8567f322f
X-MS-TrafficTypeDiagnostic: HE1P190MB0363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0363D25223AB4C63FF4D93BB95240@HE1P190MB0363.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RD2zTD7IRQjpS3jkf41fJUVNxAIfgTWp/LjDyA9upLHYBoIEmi89zoOAn+7c4dfrBjup/GoK+N2OKthOlTdz20tu5IZVeKasS71CE0L7XunncyNwTbBAJ+dOV81wS11s3GhfkRPGovgYKRy7xvhIhOWLmAIIicNv6xWynAEf1lfPJNd38ms4wgnkRXV1AbzFnC/cZRpDZttA1BtbuM6tAcjTlUunFuhreeGW18RIF9s3r0nl8pzLNTMd8eRTKWQG9Ford59DeLIv19w/dCi6otKCfKYoRDPzWlvaFR4yGuh9yR3NTsk877iKNfFIuXK/wZy6VAjS9Aj/tklF9DSWlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39830400003)(396003)(5660300002)(6666004)(83380400001)(956004)(66946007)(2616005)(66556008)(8676002)(33656002)(8936002)(66476007)(478600001)(86362001)(44832011)(2906002)(52116002)(110136005)(55016002)(7696005)(1076003)(16526019)(36756003)(316002)(186003)(8886007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: XL7ruN3ENyxH5Gqbqkpvh67s1OppsykVTvyfNPgf0ugl8snabax91lP2Nw3BN6lezST8QuZiG9kr0KxCVw19p8OAXTPpJQYhuIMK0tdn0MvuC1MrP1ecJG028EFp3pTUC7Og4zNGMqIze1C36uTjMkPqjFyyDqDK1Ugc6G5SP9SwB5BtMtREkuZnVgB4PnfPmAWXtxI9CIIL8fvLXGy/V/O2LwVvVaQtg/XMVo75wjz1p6sOmQ7/xkVB9voK0f1i+6X+WBbsNNTq+OSsRi76Bf6BggyYd0vP8kO2PjW34vsblXD2gFr6PuiSevw7d7iE2/bLTobRGfqqMJYFDvZIF9QPKbpw+hgO15x0ckZuT4J8xU+Dd8Rf9hehDnemNt0bKsyFwdhls/6939hEPx+rLEo5Fg11DsEB4m+kdMm6ZDPpv40Xp0SWOgD/Cf6VUDm4RfD/nK3hiVHEsjlkaVDG+X6rnTIsXLsMDQqqvGoGRYcn0kvGFi1Q3n3iwDb7ZjTU9jYULGrnlQfqTtep36CsqNQmlWpq4lyTKN4uFrs9k1t2OHvBpnfVS0NdsXUYRgO8upHa93yTP8pdoLI1VV9LY5bb/iLtLIHXNtD4c5yIov2LTs102zSgvrUQcSmBS8qAl1VwSZo30AQlL0TqnLJxBA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e3191886-1719-46ce-b299-08d8567f322f
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 18:19:17.7146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 54up/gjp0faq9B+9Csk5JuLcHDs+MW0C7ZfwxwHXcGGuSEhoeJUQdyTwt69yFe5w5Ys83P1crSxSYMyU2v8FlFvr+zF6t60xe8wWd+Ml1BY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0363
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'd like to discuss a concept of introduction additional entity into SFP
subsystem called SFP controller. But lets start with the issue.

Issue
=====

There are boards with SFP ports whose GPIO pins are not connected directly to
the SoC but to the I2C CPLD device which has ability to read/write statuses of
each SFP via I2C read/write commands.

Of course there is already a solution - implement GPIO chip and convert GPIO
numbers & states into internal representation (I2C registers). But it requires
additional GPIO-related handling like:

1) Describe GPIO pins and IN/OUT mapping in DTS

2) Consider this mapping also in CPLD driver

3) IRQ - for me this is not clear how to simulate
   sending IRQ via GPIO chip.

I started to think that may be it would be good to introduce
some generic sfp_controller which might be registered by such CPLD
driver which may provide states of connected modules through the
callback by mapping direct SFP states into it's CPLD registers and
call some sfp_state_update() which will trigger the SFP state
machine. So this driver will check/provide on direct SFP defined
states without considering the GPIO things.

How it may look
===============

Device tree:

sfp0: sfp0 {
        compatible = "sff,sfp";
        i2c-bus = <&i2c0_sfp0>;
        /* ref to controller device */
        ctl = <&cpld>;
        /* this index will be used by sfp controller */
        idx = <0>;
};

SFP controller interface:

There might be added generic sfp-ctl.c which implements the basic sfp controller infra:

    1) register/unregister sfp controller driver

    2) lookup sfp controller by fwnode on SFP node parsing/probing

The relation between modules might be:

    sfp.c <-> sfp-ctl.c <- driver <-> CPLD or some device

Flows:
1) CPLD driver prope:
    driver -> sfp_controller_register()

2) SFP instance probe:
    sfp.c -> sfp-ctl.c:sfp_controller_add_socket()
             creates assoctation between idx and sfp instance.
                                      
3) SFP get state:
    sfp.c -> sfp_ctl_get_state() -> sfp-ctl.c:sfp_controller_get_state() -> driver ops -> get_state

4) SFP state updated:
    driver -> sfp-ctl.c:sfp_controller_notify() -> sfp.c:sfp_state_update()
              finds struct sfp* instance by idx

------------------------------------------------------------------
/* public */

enum {
       GPIO_MODDEF0,
       GPIO_LOS,
       GPIO_TX_FAULT,
       GPIO_TX_DISABLE,
       GPIO_RATE_SELECT,
       GPIO_MAX,

       /* SFP controller should check/provide on these states */
       SFP_F_PRESENT = BIT(GPIO_MODDEF0),
       SFP_F_LOS = BIT(GPIO_LOS),
       SFP_F_TX_FAULT = BIT(GPIO_TX_FAULT),
       SFP_F_TX_DISABLE = BIT(GPIO_TX_DISABLE),
       SFP_F_RATE_SELECT = BIT(GPIO_RATE_SELECT),
};

struct sfp_controller_ops {
	unsigned int (*get_state)(struct sfp_controller *sfp_ctl, int sfp_idx);

	void (*set_state)(struct sfp_controller *sfp_ctl, int sfp_idx,
			  unsigned int state);
};

/* implemented by sfp-ctl.c */
struct sfp_controller *
sfp_controller_register(struct device *dev,
			struct sfp_controller_ops *sfp_ctl_ops,
			int flags);

/* implemented by sfp-ctl.c */
void sfp_controller_unregister(struct sfp_controller *sfp_ctl);

/* implemented by sfp.c */
sfp_state_update(struct sfp *sfp, int state);

/* internal */

/* implemented by sfp-ctl.c */
struct sfp_controller *sfp_controller_find_fwnode(struct fwnode_handle *fwnode);

/* implemented by sfp-ctl.c */
void sfp_controller_put(struct sfp_controller *ctl);

/* implemented by sfp-ctl.c */
unsigned int sfp_controller_get_state(struct sfp_controller *ctl, int idx);

/* implemented by sfp-ctl.c */
void sfp_controller_set_state(struct sfp_controller *ctl, int idx);

/* implemented by sfp-ctl.c */
/* This might be used as ability to notify changed SFP state to sfp-ctl.c by driver
which then may find struct sfp* instance by idx and call sfp_state_update()
which is handled by sfp.c */
void sfp_controller_notify(struct sfp_controller *ctl, int idx, int state);
--------------------------------------------------------------------

Currently I do not see how to properly define sfp_state_update(...) func
which may be triggered by sfp controller to notify SFP state machine. May be additional
interface is needed which may provide to controller the sfp* instance and it's idx:

int sfp_controller_add_socket(struct sfp_controller *ctl, struct sfp *sfp, int idx);

void sfp_controller_del_socket(struct sfp_controller *ctl, struct sfp *sfp);

so the driver may create mapping between struct sfp* and it's idx and call the:

sfp_state_update(struct sfp *sfp, int state);

Regards,
Vadym Kochan
