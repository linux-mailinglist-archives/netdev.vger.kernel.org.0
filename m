Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56EF5138F27
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgAMKd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:33:58 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:51720 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726133AbgAMKd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 05:33:58 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 8C27BC05BE;
        Mon, 13 Jan 2020 10:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578911637; bh=7h7sF/cWD7D1q3YsPr141shuUQYRbZwzf4h1krCkHEc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=dZDPKYDU0+JGIlYhdm5y8SZgbvLHNxWUwEAJUdp8EdLTBbNXUYZ4q0rHEKhVT2DZE
         vnAR6SLk4X8FOyX+uAvEc46oZykbTPeU5HP56kVJk8IZVqjXBte6BwYFBkTmsHG7Fn
         ggpdgK0TqLMoqoh7f7DqM0egWM+wEFx3TRvm0lwwzcNrt/CyIaBDO/uP3RTvM+69cY
         PSxy7E6TQOXGkIa2+1n+H4nMkVOK0GjmHRkykT1K1qqZ3KIqR7an1CcCEF6JAprDoT
         Lmt3hvwC/+xltsVr0Vfa6LmJ2gKEkNDPYqiJRDtRX8+P3VQ0jaxWhIBzd2iqIWzyhW
         2HdJrCHviHIZA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C2780A0085;
        Mon, 13 Jan 2020 10:33:55 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Jan 2020 02:33:55 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Jan 2020 02:33:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdoALJ/MSGOcCNYbQXJdAEIPqR8+rEUruKpGZs7pw2CQuv4CMcclUrqIzJnFceIDXPR5JxW3L9qvfNxYN0RNPBaGjjYDtTPDzfo1OcYz1cPCJw1mOaXD78rsywaAM14/EEF2c8zTX7y7EHmnAdQ4+BNyFuPHXWkRkRegJZQNU8E7392FxxxcLHtbe4FWIjT1Wixmw0dKPxwHBj/2eoQNvVYqWauxmnZouGBcaI+8SYZkDrUfJmtnmM6PWRyQjmKWuP+aGs4GWidr7WOw4xFt6zcySYtXJKTuNSnxbZDoxdYIKi6Yb4iQKMgT/oBtiOn5pnxcyDgkqRXFqJui++rw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7h7sF/cWD7D1q3YsPr141shuUQYRbZwzf4h1krCkHEc=;
 b=Fmlfh1wSQS8w+52QKWIjdKEr0g5aaZgHlC2If+ZF6W+i8TpM0/kWHhDhI9Myt4Svp4WNMfCe8TeyNMs9pWCnM8eRWWV+INPsz8S8xLbvu1DJFddohLpwR7OY5a5QZ74b4UB0olyX7Y/mBSvNmfthjJUiR5Di78olcztRkIBVuLli2EIHLuOtNsZQPCCCFvsvv9+z0ZM9RukOg8/94v+Asduq8EqoIcQADVbUAJ7ah1WS1kir5FQ9gRBFCWFE2XeLORq3cHhA5DErZVcYSbdgNr9QQbXVWbRJRnarnmB3f4k+XWkgqOE7cxu5ddgfGBRVzZTRj9MuzPd5KeveqERVfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7h7sF/cWD7D1q3YsPr141shuUQYRbZwzf4h1krCkHEc=;
 b=PiGagw386WW1F8pNsgCca7l1WcDSvuZH27Kh4Q2KW2sVD18Z5NCvzSdBszwB33r1XMHl0AVL8vHUL+vX3DSiTa1ZYfeUaUvKUsnQe+ZcySXnpIBGm/S+Hmbq6NPkm2n6haLHC6yucXG7LebpmLH0mgjvZ/9v8hEIpOhjsCv8eqQ=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3155.namprd12.prod.outlook.com (20.178.223.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 10:33:54 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 10:33:54 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 4/7] net: stmmac: Fix priority steering for tx/rx
 queue >3
Thread-Topic: [PATCH net 4/7] net: stmmac: Fix priority steering for tx/rx
 queue >3
Thread-Index: AQHVyfozEt+278ljEUiIZ6nV3ZPkrqfoZRcA
Date:   Mon, 13 Jan 2020 10:33:53 +0000
Message-ID: <BN8PR12MB3266F6242596920E608021ACD3350@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <1578967276-55956-1-git-send-email-boon.leong.ong@intel.com>
 <1578967276-55956-5-git-send-email-boon.leong.ong@intel.com>
In-Reply-To: <1578967276-55956-5-git-send-email-boon.leong.ong@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5daceb8-73cc-4118-c5f1-08d798141697
x-ms-traffictypediagnostic: BN8PR12MB3155:
x-microsoft-antispam-prvs: <BN8PR12MB31552649F08D5D9B3C6AEDA7D3350@BN8PR12MB3155.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:605;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39850400004)(346002)(366004)(396003)(136003)(189003)(199004)(64756008)(54906003)(86362001)(66476007)(8936002)(2906002)(110136005)(81166006)(81156014)(316002)(66556008)(76116006)(66946007)(66446008)(8676002)(7416002)(5660300002)(4744005)(478600001)(966005)(33656002)(6506007)(52536014)(55016002)(26005)(186003)(71200400001)(9686003)(4326008)(7696005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3155;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SOCI3R1qu5FH6vwNlNNZ5zK023Wxmae3wtG4JiEbmUl7J+Ozmh6KpZbWiPR1Vi6fVLsK4M9Vz2NP3drCDRQcsKw1pItrAVWMlqnnxTStteyNw6q9iVKvwtRqsa8WraOO3LK4UHhFZVGLKDkqKGJ2ZpYYVCk8K6RVJAnuGp8t6RhyT0+i4dheAaQl0v6RtxXu+pizu8hP37lrD3rxvbCaL7jXxU+T39LWMpS+ck7OCQcn6Vlb6AMxYocZiR3GD8DD4qGkE6LtpoB4fsr9DFig02IwfMME2wHKKdHfo2jYDmUzcnUdi5CvlRkQpU41qkxAlC1BnUFZWyXqI8qJ4yqyjjQwMVDp87/eR+7jynNQG4wFLrJ22DOvwZdlj7sAcl0scQPL9KSgjP8Wnq9xww3AF7GJ6I+mWiVm07weCtOeVy0febI1GK4uOouYOiL6H7yOuQn+YRxwnpGxKdV4TXo8Iz6YRzNGLi6cKlNfaV1G23A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f5daceb8-73cc-4118-c5f1-08d798141697
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 10:33:54.1148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iGhki2WwkzAFDrc0bkGBSEwlu248NX3eNDg6vq93SX9Iur1rpQon2QkrbxqY/8wwDmYkuZD1MmnMCY9kCQzgpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3155
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>
Date: Jan/14/2020, 02:01:13 (UTC+00:00)

> Fix MACRO function define for TX and RX user priority queue steering for
> register masking and shifting.

I think this was already fixed as seen on:
- https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commi=
t/?id=3De8df7e8c233a18d2704e37ecff47583b494789d3

Did I forget something ?

---
Thanks,
Jose Miguel Abreu
