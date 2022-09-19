Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F5D5BCDB0
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiISNxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiISNxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:53:32 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AF42251D
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 06:53:31 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28J5EY4C010907;
        Mon, 19 Sep 2022 06:53:17 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jndrmpf4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 06:53:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIyvZVjWygu35hkcIWp61xQlc3U79RUPdWLSM9ynBtV8hh4F+JEJIRaPa4RWaXfKAtBI868nNl+lPIbb+Ycyh8OZMvnhXYQ3gX6m0vJoX95fj1Q1XWxy9nBIzCPb+pcVCPxhcknbN733Ajk6HqcXKeGDx+8SZ4pDeDdqvZnh2ZpPENn1ZtBT2r0YrB3MpPfJvvAnsp6D2w90ChNBjSONe0vkJMY8BR5ivLFvxwvXAHlWQNhiZg+xXyNOyyHgsCOwCqNoLynYA+NlmesflyBL83EU9bJQjJWG3V9xO5pHYabWzsixY/bg3N0tBg/v5yvdPSsMcy9NHixVpkAZZiTS1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nplIUXiGBPigHIpWrixwFyoJ7jhQ3pVIwtFEyirbJGo=;
 b=Mvpu8CVXNFCLhM/4d2EqozT9nTDVfbq6kwzQ0yqjjPvEDDLvr2ggrGecOWidoodYz+k+fvtw1HxrEEm8oIbDHSswOt1xdEDHctmDXi5SaIhTJIZTCeNQBPcEX5D+sFPektdAwE3+wpGl3X7FQxcvIpL+Acu7uJXijBmMFXrr/pG48MoTZutw6ZLvov6rUmZcm+VWvqG6xpmcJK5mgQagBGbZeEsvbWW5YzHVSaJZFDIbeqiAfH4ZvxBNB7R92xS00zAJyP9zWbZwtuCog9HFVLpBPhLPYGfwUxx6ca9a8/C5kzPDb4vXmiWfRU8jsrlbqAcMAh+YzIbZCWaYdXzMNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nplIUXiGBPigHIpWrixwFyoJ7jhQ3pVIwtFEyirbJGo=;
 b=JjBKtXTFN0WX3V9qD0aobES8zjUYpDLuFH2X/KZh5KH1X3VacFVlCGuw1EV9WUYjmB5NSdS6Yw2wB/ihaGh3jPW+o+9cDGzVrmJmQqp2/R6CPpXcV4tTCrQTYJhafW7d2QD2jUcy2preh8myJUn3N3Bz1BZ9AjPX89PeYI/uGv8=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by PH0PR18MB5189.namprd18.prod.outlook.com (2603:10b6:510:171::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Mon, 19 Sep
 2022 13:53:14 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::3406:4f9b:81f2:b078]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::3406:4f9b:81f2:b078%3]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 13:53:14 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Thinh Tran <thinhtr@linux.vnet.ibm.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Alok Prasad <palok@marvell.com>
Subject: RE: [EXT] [PATCH v2] bnx2x: Fix error recovering in switch
 configuration
Thread-Topic: [EXT] [PATCH v2] bnx2x: Fix error recovering in switch
 configuration
Thread-Index: AQHYygYMN6Jy0latzkKMXfSSgh9Kxq3mwECw
Date:   Mon, 19 Sep 2022 13:53:14 +0000
Message-ID: <BY3PR18MB461200F00B27327499F9FEC8AB4D9@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20220826184440.37e7cb85@kernel.org>
 <20220916195114.2474829-1-thinhtr@linux.vnet.ibm.com>
In-Reply-To: <20220916195114.2474829-1-thinhtr@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWFuaXNoY1xh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLTY0ZTgwMGMwLTM4MjItMTFlZC1iNmMxLWQ4Zjg4?=
 =?us-ascii?Q?MzVmNjc2YVxhbWUtdGVzdFw2NGU4MDBjMS0zODIyLTExZWQtYjZjMS1kOGY4?=
 =?us-ascii?Q?ODM1ZjY3NmFib2R5LnR4dCIgc3o9IjM4MjUiIHQ9IjEzMzA4MDY5MTkxMjU5?=
 =?us-ascii?Q?Mjg1MiIgaD0iN1ZVMC9jQUlRaEpCUVlvRzQ2QkQrYkkzVm5VPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBUDRGQUFE?=
 =?us-ascii?Q?VXpla25MOHpZQWF6cnFidFozRHRVck91cHUxbmNPMVFKQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQ09CUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUE2UHFlbEFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3QndBR2dBYndCdUFHVUFiZ0Ix?=
 =?us-ascii?Q?QUcwQVlnQmxBSElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVB?=
 =?us-ascii?Q?Y3dCMEFHOEFiUUJmQUhNQWN3QnVBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdR?=
 =?us-ascii?Q?QWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFHMEFaUUJ6?=
 =?us-ascii?Q?QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3QnpBR3dB?=
 =?us-ascii?Q?WVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdjQVpRQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCa0FHd0FjQUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFi?=
 =?us-ascii?Q?Z0JsQUdRQWNnQnBBSFlBWlFCZkFHWUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?R1VBYlFCaEFHa0FiQUJmQUdFQVpBQmtBSElBWlFCekFITUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQ3dBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQWJRQmhBSElBZGdCbEFH?=
 =?us-ascii?Q?d0FiQUJmQUhRQVpRQnlBRzBBYVFCdUFIVUFjd0FBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4612:EE_|PH0PR18MB5189:EE_
x-ms-office365-filtering-correlation-id: 4d371d2b-746d-4ce8-9cce-08da9a464c3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vikF5y7cldUELxZkf4GI7Ls3eye+yL4yrqs1Z1nKVe+Xysqn7nfEjThiV0Luuh9gu4Q9Oy3pPheSDNmEdjs6WlnnHwzVcvtN9pBHfS+ghw1ikj55JuyosccaFhFOo7D/GamjG4TZMUzKGhLe38vBhi6kXW441fCjvlLmBhxKpCiJy4or7eLHY7Bvv0sfH51P3hsTuH4sdXVj3TqoyRKPK9QSMQ+i1Ew1tWfmU2ZK6BTF1qri5OmVI6oYo9yDeXrN3aJc135i3c/0IxJvpKSqlrmN4zZiU3iYebhcMy9APK+EXYG/qW7eWwEO1nr2hMWqT9JbGTeEV8wDIDYssOq8ylHElHZkLCTZ38P23LtiZu4qFgCxPz+NUJLOejO1etXjz2COMJpZx5l8Tl6yehoh3V44Tfb3tA5SNqS6mpfqmXweqQWGg+Srl1CW1KjXXBgekF409VBVZBBgxlmZHUqAXHdsQ+IBC38ZiHQkBiCZZnwBxTzvV7jZjh2isCqJwA8Q2EzphUhTbxPZkpoD8cflRxucBQYKjwIqmIdKtRbHiw1tnjY1DEYzq3GUXa46TfkgpBdhXbm9l8yes3qQq4eba8e/8xE72XTT34yUMWXyxrXCDK+wBFkfTRsObVzafXqZyGd1opmkfCuxUpGzqscL2boeRID17ay2ox6dTT7wc7CYtkLTmHHidFn7395cROtEfZmqRI0M53GdmL4CkgMLDpds32Y8wPXCQ6d0+BuXVG+MvTNlnCIL9E4v5Q47oKUt+tkBxoubL9AdjPoM+CBsqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199015)(71200400001)(83380400001)(41300700001)(64756008)(5660300002)(478600001)(316002)(26005)(86362001)(122000001)(8676002)(38100700002)(110136005)(54906003)(38070700005)(186003)(2906002)(4326008)(33656002)(76116006)(8936002)(66476007)(55016003)(53546011)(9686003)(66446008)(52536014)(66946007)(107886003)(6506007)(7696005)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B6BsmhgwMnTz+2q5G5uAtrtIlMSJ0sJxcVin3Aw7YeGTPnMwMwkRBz/7jNfs?=
 =?us-ascii?Q?ro4jfOOUYo/CfJDbUaGPoYXeI3D/cYkBnLsVCiopy7Cq2cGqD0cVFl0t04uS?=
 =?us-ascii?Q?pZ6wGYc6RpWAE1ClRa+6P7TkigjvduPwhnuryy3stF8r+zT74wvZ6iYvXOMp?=
 =?us-ascii?Q?t8mwo4kh89lw7zXeQ7okmNT5zmDkLHUPIab0ztaZDQQPi20AQH6beSXqWnXI?=
 =?us-ascii?Q?E+pPW3MTnEcFcCn8A6nfpzWv3vquNQWGl66ho2ig5/tf/wtf14qemh5Iat/g?=
 =?us-ascii?Q?GDBJ02izXlNM5QK6hBNRIrk0+F0Tya15fg1HriNJymgnILHdUVjN/l5mA9Rm?=
 =?us-ascii?Q?AIOeq0QQ3qr5H1NkU2KX/kTtBmEezL0iL/AWrgrL8rfmEkcJJuIuZvJwVbsp?=
 =?us-ascii?Q?2IVLdFdId3fqHzSsV+voQn/k7NE+Vsy5T5Ry6mCX2JHBLHWtiKi/yH5Q9ILm?=
 =?us-ascii?Q?b0wB0jouC/l0Dl5OTKK/C2aqd75uIJ+tucxGSqhLjLmQT8ktWhmqQUzYSTLy?=
 =?us-ascii?Q?aoyl536O6putfuVtAx8Zg8dIf5KFnRgIv8ukRmUyLrilvkQue6NFieH39WL3?=
 =?us-ascii?Q?ytCKlm/AgQH9gOXmhv5BAVSzUVdF42ZPOE7DSViHhvEURQuUFd2uuGlusOW1?=
 =?us-ascii?Q?69EqYhZCVmiM05F/A6hT4C9d8Ex0365AuvJFkXsTySS/Sz1PfdIsY4ut/eav?=
 =?us-ascii?Q?cKGYvVOWBFyQfXZkBvkfuyUGBNM8PIKBuA+3vxuugQVefiaasK+iw5A1VmgC?=
 =?us-ascii?Q?eEIt2/qTrS4Q1Uwylwd6TEnKweFbMydUy6uNUxwrbrFszPTG1KfC1iVr+zu5?=
 =?us-ascii?Q?bKLIRvv86a6G12dpXxZfT45FewWwPhqXfJpLHwGD/I6dvoq6wI3ROGixqGvR?=
 =?us-ascii?Q?ojIpL7YpeL9wkR2BQz7XlaC+oXUczDy1VJk6dLNcwczPsSvz7teTS1jrNYKW?=
 =?us-ascii?Q?xNgs+rpkijzOSMjzvzcqx5onIYzrH+YtILH7JNzSa79Zl4gcMzNxe/m/grWA?=
 =?us-ascii?Q?Ql3GHY0fo9m3giYjei6J9u9eSa64Bjx6+y2+G85VRnjJ/eUz8KH2rwBLaZ85?=
 =?us-ascii?Q?gyjbaxH0jCfAbmjWbcNEX/aUr9TFW3NHEz3Bul1m8gTBd6Fl2k1blbbvqmXN?=
 =?us-ascii?Q?Valkfc2MPY5MGuPsVcQmksXIhN3e/rkj7/A8KI2ppBnkRnX5asttzJJPFj+B?=
 =?us-ascii?Q?6FdxzyjZ8yfg5hdbRCpI2LVocCkDflkGpJFmn6qmc/lq4MWqXp+cgSRI3aKd?=
 =?us-ascii?Q?Jo5ChTb5DYygXQcZe8lmkytKV4vxobOB3SJ74ARGqn84k2Uw5llBk9h/CaDz?=
 =?us-ascii?Q?2XQzITlenYxx+tlTftUKdW3kiR6PYtT348KBuTkRX8rITbS/DQSaThJ+aMv6?=
 =?us-ascii?Q?PsbQef/pD5BzOza2ewjVxag+60pRnpclv80Bh5nBnGa6OoHen4gHLzTKpICn?=
 =?us-ascii?Q?p7EuOZtigi/ZN0gW3U/Xeda4iDprThcv19CPEBrTfGgXGuWMG+Un0MBBXiWv?=
 =?us-ascii?Q?s2GG+GzFjebtdtEOj6wO9DSrew9SUQG5L3o+ygQXZhgLFQtRdmtR3IR/gRTv?=
 =?us-ascii?Q?K9Az1YG8wcmhzIs60spzdlhHt2mRu6QsJezxVjWC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d371d2b-746d-4ce8-9cce-08da9a464c3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2022 13:53:14.3281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gGhA0co+nYzAPxMZ/ByMxTknI/jPCKpeJGB9JsWi03EHios3nY4ed29+VL2B3+2fvRQWUlT5yODjYEEAtu3MFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB5189
X-Proofpoint-GUID: SklyKC2ABRORLlq8s3oUX-Awj0raPk3c
X-Proofpoint-ORIG-GUID: SklyKC2ABRORLlq8s3oUX-Awj0raPk3c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_05,2022-09-16_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Thinh,

> -----Original Message-----
> From: Thinh Tran <thinhtr@linux.vnet.ibm.com>
> Sent: Saturday, September 17, 2022 1:21 AM
> To: kuba@kernel.org
> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>;
> davem@davemloft.net; Manish Chopra <manishc@marvell.com>; Sudarsana
> Reddy Kalluru <skalluru@marvell.com>; pabeni@redhat.com;
> edumazet@google.com; Thinh Tran <thinhtr@linux.vnet.ibm.com>
> Subject: [EXT] [PATCH v2] bnx2x: Fix error recovering in switch configura=
tion
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> As the BCM57810 and other I/O adapters are connected through a PCIe
> switch, the bnx2x driver causes unexpected system hang/crash while handli=
ng
> PCIe switch errors, if its error handler is called after other drivers' h=
andlers.
>=20
> In this case, after numbers of bnx2x_tx_timout(), the
> bnx2x_nic_unload() is  called, frees up resources and calls
> bnx2x_napi_disable(). Then when EEH calls its error handler, the
> bnx2x_io_error_detected() and
> bnx2x_io_slot_reset() also calling bnx2x_napi_disable() and freeing the
> resources.
>=20
> Signed-off-by: Thinh Tran <thinhtr@linux.vnet.ibm.com>
>=20
>  v2:
>    - Check the state of the NIC before calling disable nappi
>      and freeing the IRQ
>    - Prevent recurrence of TX timeout by turning off the carrier,
>      calling netif_carrier_off() in bnx2x_tx_timeout()
>    - Check and bail out early if fp->page_pool already freed
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  2 +
>  .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 27 +++++++++----
>  .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  3 ++
>  .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 38 +++++++++----------
> .../net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  | 17 +++++----
>  5 files changed, 53 insertions(+), 34 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> index dd5945c4bfec..11280f0eb75b 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> @@ -1509,6 +1509,8 @@ struct bnx2x {
>  	bool			cnic_loaded;
>  	struct cnic_eth_dev	*(*cnic_probe)(struct net_device *);
>=20
> +	bool			nic_stopped;
> +

There is an already 'state' variable which holds the NIC state whether it w=
as opened or closed.
Perhaps we could use that easily in bnx2x_io_slot_reset() to prevent multip=
le NAPI disablement
instead of adding a newer one. Please see below for ex -

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net=
/ethernet/broadcom/bnx2x/bnx2x_main.c
index 962253db25b8..c8e9b47208ed 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -14256,13 +14256,16 @@ static pci_ers_result_t bnx2x_io_slot_reset(struc=
t pci_dev *pdev)
                }
                bnx2x_drain_tx_queues(bp);
                bnx2x_send_unload_req(bp, UNLOAD_RECOVERY);
-               bnx2x_netif_stop(bp, 1);
-               bnx2x_del_all_napi(bp);

-               if (CNIC_LOADED(bp))
-                       bnx2x_del_all_napi_cnic(bp);
+               if (bp->state =3D=3D BNX2X_STATE_OPEN) {
+                       bnx2x_netif_stop(bp, 1);
+                       bnx2x_del_all_napi(bp);

-               bnx2x_free_irq(bp);
+                       if (CNIC_LOADED(bp))
+                               bnx2x_del_all_napi_cnic(bp);
+
+                       bnx2x_free_irq(bp);
+               }

                /* Report UNLOAD_DONE to MCP */
                bnx2x_send_unload_done(bp, true);

Thanks,
Manish
