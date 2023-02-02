Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A166887D2
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 20:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbjBBTyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 14:54:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbjBBTyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 14:54:32 -0500
Received: from BN3PR00CU001-vft-obe.outbound.protection.outlook.com (mail-eastus2azon11020020.outbound.protection.outlook.com [52.101.56.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D46A4DBE5;
        Thu,  2 Feb 2023 11:54:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUnLT5WLmCRFQAFRESH0XizyYYsgdGmg1ujcHbPGvo811HvwsBZX8PUP8hCbzph+MAGWiLj2JqY62ujBORqEoh6bt587P2BYMIW5UweS476b0iL3kbFq43Og3y3nfUZq4Yx+tovDe0Z4MbSeG29OK48kFoTh4YhlgAKCuy6JfMauEoZ3XlyuC38zCggrfoBHfb8DhosgUuHyUJVrs8ecdclUo0e6RkDQ4Dvj9jG5V/0g2dznLs2lEKpEuY0dFGGn/oPbVMg58W5DirxPoCGqzeWHiSfQYKzj/M24IqHt2UbH5op1Ko77WZvPGM89gdiBYRfdo5Hw0zQs0Fwrmqq/qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVN1WlPFUu9If4QlzdfHOE8TSRylAvVvN8jB1ZJz53s=;
 b=eviRjGIO3oPijfQnf8t/N4T1CmzVZzbZywd5f5rbZP4s8Tl5pd1sIIdfpA2d3cQh/eDEbzxP787CPX/uyFYIpHmoDuUbFa2nq2oN85KT5Ad1iUCvSVAmAMtzpMLoJRXPTz1IkBYW3kbh8CQNa5opw4lHbCZRnGNcL1IMSUPG7nIzpdkgtNNCE8LAix5SHfCAk10m2EOcv4GNTkitKZLGIQTCVW4kgbJs+qyU/4jTM9y6RHmfTdy3Atap/4yilLkhkXNuca+MVj/NrPXlR3ShDJpgwOUOMZJxFf+jgamK/46Mpr86rUDWEA+d5dcohTd4QxRbBNtu81TZBCEe2/IGfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVN1WlPFUu9If4QlzdfHOE8TSRylAvVvN8jB1ZJz53s=;
 b=P/Fx5+FnHXCQgRJesXlJZSXE2VGOQu4DiBu58j5h26vcMiQVIsSUY+Igz3MqU1IYwv0wIruiLUEh8w0XQrsc333JoXFfZVEhfremHxuPS4LG5GyWacmN409Ufu9vd2sl3W7WB1DAMPxvIGZquhWhd77dfFg58R0r/Y62JYvu9SQ=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by DM4PR21MB3107.namprd21.prod.outlook.com (2603:10b6:8:63::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.5; Thu, 2 Feb 2023 19:54:29 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::713f:be9e:c0cc:44ce%3]) with mapi id 15.20.6086.004; Thu, 2 Feb 2023
 19:54:28 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net,v2] net: mana: Fix accessing freed irq affinity_hint
Thread-Topic: [PATCH net,v2] net: mana: Fix accessing freed irq affinity_hint
Thread-Index: AQHZNobEMZyFqcNhx06LWWmexoAl6a68DsoAgAAEbaA=
Date:   Thu, 2 Feb 2023 19:54:28 +0000
Message-ID: <PH7PR21MB311685D9BE6CC5F99E9CC2D0CAD69@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1675288013-2481-1-git-send-email-haiyangz@microsoft.com>
 <20230202113828.7f2a800c@kernel.org>
In-Reply-To: <20230202113828.7f2a800c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5725e106-0fbf-4c51-ba2e-89c2155b597c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-02-02T19:54:17Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|DM4PR21MB3107:EE_
x-ms-office365-filtering-correlation-id: 9b165fd5-4226-4d42-3ba0-08db05574b6f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wtRtZszQWipObQHbfS2nfpcijHfpGc1HjKLL5G05wqXwqCxLhSiybXVN9KoJSzfkTYPCZTfiYq417ZkaR+1sa7KlBlgMnfQnwb0zzyX1XPp1zgErc3ihuOjgFEvfCJh5upH9E37+xWAJyQXFQqhZTiGx8SXMVCVmCB890NgnrEhehKCZ/j08hphZmepSLnlSWNdRkQFYjq+gxZao41I7rthbwbiW8nw9wSUaBr87qQCgoLvIcHXjbGIb/5hwOwdxXPQiclRUs1k4jIcC351qWb49vnbZFdGkLhdlqQS2QmPbFXeP4fn/CmI7cSdTCqsoyGlcydE1SYKFMpZNWLnkw1by544URmwrRbIdsX7B9C9IJBAwyAoPGLCj000JzV37PHqlSk+xbh9sHjzi0TYYmwuLKPCMnoWQ9GvU7mM+wBmGCerVaVLhopaKXuYbHiJMW+k+P+iurhymk8SYs2LZ/mT7lzliLmJ6m5KWf8iPWA+BXrh5Ucp4nEnAY9iwyhMoiosChSYG266KcDnhWpWcLvoq5sY+dBkk1CVbpF8suXXcMmC6PEXyGEILIp/yzG4w6pzm9vZHC9nHppwTtpnplUpxFotgiPztXhonUKioWdTC322KcE/OhqgY9VfVAoQwkAC2ojpwvXgDEnQD1Cuf9ucRbrc68fQtqnPzfmTixmU1ndmrCtXGet+2Vty0nbNbr8Wr+/GUiCuiD/yVsu8jRvwobm3ELETFsYV/yokZYg41BnxcD5X3m6Phny59XiwU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199018)(122000001)(66946007)(64756008)(66446008)(66476007)(66556008)(6916009)(4326008)(9686003)(8676002)(83380400001)(41300700001)(26005)(8936002)(5660300002)(52536014)(6506007)(186003)(4744005)(54906003)(76116006)(316002)(2906002)(8990500004)(10290500003)(38100700002)(82950400001)(7696005)(82960400001)(53546011)(55016003)(38070700005)(71200400001)(33656002)(86362001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4BfF6Qtpru2Ry7yarZlqkMPsQyBthdaCx4lsmCG+00v9+f+aURpVGb5xijwZ?=
 =?us-ascii?Q?vceVq3Wb8aQSCVEsBOA47H+GDs0rviVzDRqn92B7QlgV+pjM3FfR3njWrTty?=
 =?us-ascii?Q?OKD1AHzx5nPHxdapjfGt2ZKG7c7kl50qf5hIyCJ0dhjympW8BleRP2nW+2/Q?=
 =?us-ascii?Q?zE6VPF2WSGr81QOnV2BlXo8RceM39LEdtQU3Ux6J3uTas/E6CD5K1gNhHExr?=
 =?us-ascii?Q?IvRRZrLUvAxjT8g9rxJSpas/pj8Smw4blkKadUwFJgv37Bt3+XHEqtwRi8Mo?=
 =?us-ascii?Q?Q9L7jfrVDkA5nmouaCiT2X/dp/RZlJpXXSIusAQ84fvhPjU8fVJebPb5CJA4?=
 =?us-ascii?Q?2UpxEDWvNkqh8QyXgx0mAAQpqJNRWFIPWAbzMi21tLKiXzbKCEtDII8XtMal?=
 =?us-ascii?Q?dRPjwF6L5ThL9ExB+u3dfwnl8Ca9En/tp/WLxUgcvwZUohhsdrSTA/Q1BnBG?=
 =?us-ascii?Q?8dEYm4K0hgeYk79qq99H6blJBnhY/rWvNomoAz2nW6Kf7O707OIU7DPzCiR6?=
 =?us-ascii?Q?/cc9dzWXHewHdN7qg8j6s6j9QL8y4m/Oy39pbIJshtuuNOHYAjsEMWuoQL50?=
 =?us-ascii?Q?vTsWVSZWhzL8mdjKq8AuOfUnHJ+IkmMZwIlWQmTcR0D95n3dvzL3kPaDVPUb?=
 =?us-ascii?Q?OEPqXv3dBGk3tCHHymgfCKses17jwGMgoB/8A6MOa7UgX4sGSjuRyBV9NJS2?=
 =?us-ascii?Q?ipDdV/rbxOOfyAvazRgZwmrO281MFNmPd0PfZPUDDAfJNvmD0UY4FcD8dM/1?=
 =?us-ascii?Q?UhT4qd++CirdIkMBZMGR3Uult1GbN0k54IAQMYMKyiHyf4sVu2QZLexZnkbH?=
 =?us-ascii?Q?xZbrPmVbW/A2zGwdy9HjkBC4wbKBfV2xHPOg/nSZunYNRnS+Mz9B9WAlpYqT?=
 =?us-ascii?Q?zihHfP12t/POX6iNXEh6tllzJXan1fkZd4k/49/iJ+8e7AoUCCALQ0LGUJWc?=
 =?us-ascii?Q?BzX8r3bmdb6aPFmpu8NHJBrO2a8+T8l8eYkO9pK16fhTqXU7Lf4OMx8uw8bb?=
 =?us-ascii?Q?ybs9nmMMuNEpbFwPvz5cDuCEgqbzCAxdBo4HJXSqI82njHH0z10Tqo9ndkhc?=
 =?us-ascii?Q?w8GDAGed/2XI5332pjhz7CKJgjgDJOVH8JxIQ1idqYeRPW1Zc3pCUO7u1qHk?=
 =?us-ascii?Q?Qn03pKjc/Mt+sOXDuG2gjTtnD2JUjDYzIIJxnbh63ajRxGLdGw54ffO/c7a3?=
 =?us-ascii?Q?vFmyzymIpRV28qHS6qa+NQ2iPRlV2rhu3hZvx1X02x48V8yveKWfIC+FCgk9?=
 =?us-ascii?Q?/N3FHt6NCg6b7FsIlkaQvSA2Hp0HYlhVM0xjdMgDfmxf5DIjHrYTggbGkdWO?=
 =?us-ascii?Q?mc2nXdYjU5wQ1B4B16isUyPsX+wD8iOH/znV2zYvgMiVNtKxcbIid2fknYbQ?=
 =?us-ascii?Q?6WJXE8Pll2X8hoDi4p5hR0iJL3Vk+pQE2HBFSngPuZx95KwANXt6yUw25e5Y?=
 =?us-ascii?Q?LJs/NYSkKF0dVfB6wJQRtmSPqXkphg6q6QNcCx56mpIO9TpNQEOPnmIIumrs?=
 =?us-ascii?Q?gETM1UqPDU6TDRXQeMWmY+B1FbGlYx6n4vZB0Q/OH0kZcp1lgT2Ef9c9FJok?=
 =?us-ascii?Q?QY/8HMQVlLOdw6U275JuWjXnyilNCsJ1Ky9oGLt6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b165fd5-4226-4d42-3ba0-08db05574b6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 19:54:28.8294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dF7iIDnss05mVgWqyUGF4ymHAF03CrPMOjmuI8+ktwRI5C1yxRNW6CQrreTa8viDY5hdOspO0C2bpnxObybQwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3107
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, February 2, 2023 2:38 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Paul Rosswurm
> <paulros@microsoft.com>; olaf@aepfle.de; vkuznets@redhat.com;
> davem@davemloft.net; linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH net,v2] net: mana: Fix accessing freed irq affinity_h=
int
>=20
> On Wed,  1 Feb 2023 13:46:53 -0800 Haiyang Zhang wrote:
> > +		irq_set_affinity_and_hint(irq,
> cpumask_of(cpumask_local_spread
> > +					  (i, gc->numa_node)));
>=20
> The line break here looks ugly.
> Please use a local variable for the mask or the cpu.

Will do.
