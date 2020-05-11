Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F03A1CE08D
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 18:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbgEKQeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 12:34:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6818 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729862AbgEKQeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 12:34:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04BGTxN5007823;
        Mon, 11 May 2020 09:33:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=1ntoLpY1EXYE/JLYQM9v6lqRNb74Ur0sWPWsyG9AQJY=;
 b=SJeDocaJu5lh+hPd87cNPJ4LyQZHFa0T0qvsZz5uxRCSy7tXolehcPUVrbXJg2di63DZ
 3kd6vgaQ+pReOCPtORFV2IbgiRDimCH0XZXgXORa6ASmKqHzLc+iShW7JxfmZ/Bj8qJ7
 wC6Ozcm22+K0eqSS6AWaTVpXuovtrr8V2uTTtPx4hFeboXW7erHew3UWz+1W3lPY0k0I
 h2iycfS/KY3Cy6vHqBjWs/7uQAp1c8k58kKgd7eCrvpd3P/oMMm+toNDr7GevfOU1xdE
 ZQRn3rD2EaUjwxeJ9YxOT21UXHqbefd32vNAAFfZOyCkDdjNOav5QhFoxK+5nJA7wNIR EA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 30wv1n74ak-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 09:33:09 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 May
 2020 09:33:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 11 May 2020 09:33:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZpPlkeGwaNbxZkt4CXJPJSJx33p3iYYqqlBFXtJiOtVLjseBmn8BlyPEhfxp/uDVNWUvLAEa7VzhxeneSUg16ON51Tvq9s+0paw3dDJfHkgkrE2lp+BG6VlRQDvngguQDy1x8RQIdVIb099m0fPN6B9YA24YJ+GBZ4c/wQOA+J0qQXQ7d0YmoAh1PyezeIscCWWKo1z0pYqTRO3rbjhdDx6u1/cYoz1AJN/UKqZQP/TFzkxuOLyhZrzCd6/NxZLIf+8pQ8sFxjQWVn4BmlQEv5Ch9UXt7EhID4TxrGaizKPapJ+tZMMhWgpY8bPMBQ3H9/2dOMup6NedzTLv7dEEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ntoLpY1EXYE/JLYQM9v6lqRNb74Ur0sWPWsyG9AQJY=;
 b=cvMrjVtf+4fEFLw6mwhls2h6WxXccr9X6RjJCTuKAudl8MFfQWU30P/MFaQWVvZJ2LUG4vz6Oq9ohuSMQ6Swm4idiMD+HDhOkSDnedSOjtsCctvV5/be4gUhzDmyLUvzG/gjOLWvKLWrQQelztWw43zS5Iyy4hsNbRuPvZAHh+P7GFWUoxxxoT57IFM/LtNlgRowl9j0uliPLAe11QIMt77vlv9ihJgQRQ0tiKL515xb9L4Ad7KqqBydP+lVcZAo1EZiTiU5WgCfViWK/7P2wYsL+HYXaUQ/GvbdByw2FphDqT28LvYruVO9LSKtf+FyqpAbWDRp6rE2RXyr2MQa1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ntoLpY1EXYE/JLYQM9v6lqRNb74Ur0sWPWsyG9AQJY=;
 b=CV7bmQSGcfIEsRtJ5lcVQ/8646UkbsHJCyToGKQ6VDXa1DAE+rqNjlNJBXxd/SM3+P6sPAs8Wf5dnON1tqA7HrVTs5IyDFVZBvMqDpo5LhSGfmt4g3NSKdcaFaOmyhKl5DL4DUroaltdF+J7cDq3yth5ez81udqwsqM8ehKxNJk=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by BYAPR18MB2872.namprd18.prod.outlook.com (2603:10b6:a03:10c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Mon, 11 May
 2020 16:33:06 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::85ea:1855:948b:5319]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::85ea:1855:948b:5319%3]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 16:33:06 +0000
From:   Derek Chickles <dchickles@marvell.com>
To:     Luis Chamberlain <mcgrof@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "aquini@redhat.com" <aquini@redhat.com>, "cai@lca.pw" <cai@lca.pw>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "gpiccoli@canonical.com" <gpiccoli@canonical.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "tiwai@suse.de" <tiwai@suse.de>, "schlad@suse.de" <schlad@suse.de>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "will@kernel.org" <will@kernel.org>,
        "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Satananda Burla <sburla@marvell.com>,
        "Felix Manlunas" <fmanlunas@marvell.com>
Subject: RE: [PATCH 06/15] liquidio: use new module_firmware_crashed()
Thread-Topic: [PATCH 06/15] liquidio: use new module_firmware_crashed()
Thread-Index: AdYnsP0a5g7oreZeRFqq0nCL48o/cQ==
Date:   Mon, 11 May 2020 16:33:06 +0000
Message-ID: <BYAPR18MB242361E91411E5CFF91D5DD0ACA10@BYAPR18MB2423.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [76.103.165.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 351b7cb0-b14f-4d52-a401-08d7f5c8fc21
x-ms-traffictypediagnostic: BYAPR18MB2872:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB28726B95395C8A3B9B75D775ACA10@BYAPR18MB2872.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04004D94E2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +nOXyrTcSzT5xd0MFttWKBcfp7I+lgoAvJ0vuE/wdTvEccW6urZE7DgGxvtSk+DORf2XP15RVXGty8GIHLr4sB+v/pZioEKCik6+n/LQADYBOl5Lp2+ZPlRokAld+XrC60ZdPCSXCvQz79WB8sih3iPBEEhZMF3MQ9wzW1kqCvvADBb5mJDc6CllWdlELwaSkDt7Ze6cH9BsrGeBx+a60XOqoXIYgI38nohnoCh8ZQsjTmLOtM0x4skHuXWbllGDX83fjnCsvHSecOUK4qGnARDqSYzAfNvNfynS+h1G8QX2IqlQmyQ5MJIaFY9cMe6EkFyYRZoHzytnLjTp4l26hJ4hPq5mwPsBXNC1KI6cE+aWUMdT3WJuSvUmhS6sG8yYuwT5GWUVAhOVqhniOI/dyLRWyGEHJOIt98B7ocaUDldkLLXbf7dV8jmXJNRQ++070kKdNUpY7IK0ks0c+78ntGgKSGMYp+Ju6RWzSA165TWmlckM+/+NSWjTfd/jcuq20WTLlBvc98NhOmQr2CRI/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(366004)(396003)(39850400004)(33430700001)(33440700001)(316002)(110136005)(52536014)(2906002)(71200400001)(7696005)(4326008)(26005)(478600001)(55016002)(9686003)(53546011)(6506007)(5660300002)(186003)(54906003)(86362001)(107886003)(8936002)(7416002)(33656002)(66946007)(8676002)(66476007)(66556008)(64756008)(76116006)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1/hel/TFVfsn0SD3pNrXghTMt6BJeEBI5o6pOXyUsf+bV5Nk+jlMlTu0ukhaBeekrtZMSWKVU/FGSKOwDO4Yq6Fuu3IqVA092HvG+cJPrQdYqGy70QlEklpsh49MPv2MlXhCeQXHYNgTz8tnJqQKNwm27noVHNQappx3//y7wW5O9Vwp9wXL/a4GAjiu941kFFTVyzrMtslqpGWfwhLEsC56RMp2uTPn0FT3t60EXkrs1jxlKcVpgSRN0CG+WYqGE/AQVnu3Gn00uasz1w1ZdhnLBzaEOSb6vy8GMClOjtKS9EYQ9WLybukvyf2xGO8F+mrjgcOe6AK0YbqlClqZ2gD9Gtoc2tKUXkVouv/LoVHr8JkM1w7IFdze2GpxZpZ+yny+3TjVnFb9L88V+2SelflBi8z9oNWoBWxx+9/nhc662E4ZIpeyB02bbvdDA0dWpEG48QiLlhTETVzMfZjF4wwrZlNOROJ7mKHHGOY+dPA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 351b7cb0-b14f-4d52-a401-08d7f5c8fc21
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2020 16:33:06.7422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qaH/L0gN3WQVDHmbJvJJEmxOo0sflOF/nKhG5+Pqt6ht/L3Z1aoxhFL0ByqZaB+s0xKR3SO+U9WqL/cS5Y/6iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2872
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_08:2020-05-11,2020-05-11 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Luis Chamberlain <mcgrof@kernel.org>
> Sent: Friday, May 8, 2020 9:36 PM
> To: jeyu@kernel.org
> Cc: akpm@linux-foundation.org; arnd@arndb.de; rostedt@goodmis.org;
> mingo@redhat.com; aquini@redhat.com; cai@lca.pw; dyoung@redhat.com;
> bhe@redhat.com; peterz@infradead.org; tglx@linutronix.de;
> gpiccoli@canonical.com; pmladek@suse.com; tiwai@suse.de;
> schlad@suse.de; andriy.shevchenko@linux.intel.com;
> keescook@chromium.org; daniel.vetter@ffwll.ch; will@kernel.org;
> mchehab+samsung@kernel.org; kvalo@codeaurora.org;
> davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Luis Chamberlain <mcgrof@kernel.org>; Derek
> Chickles <dchickles@marvell.com>; Satananda Burla <sburla@marvell.com>;
> Felix Manlunas <fmanlunas@marvell.com>
> Subject: [PATCH 06/15] liquidio: use new module_firmware_crashed()
>=20
> ----------------------------------------------------------------------
> This makes use of the new module_firmware_crashed() to help annotate
> when firmware for device drivers crash. When firmware crashes devices can
> sometimes become unresponsive, and recovery sometimes requires a driver
> unload / reload and in the worst cases a reboot.
>=20
> Using a taint flag allows us to annotate when this happens clearly.
>=20
> Cc: Derek Chickles <dchickles@marvell.com>
> Cc: Satanand Burla <sburla@marvell.com>
> Cc: Felix Manlunas <fmanlunas@marvell.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ethernet/cavium/liquidio/lio_main.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c
> b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> index 66d31c018c7e..f18085262982 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> @@ -801,6 +801,7 @@ static int liquidio_watchdog(void *param)
>  			continue;
>=20
>  		WRITE_ONCE(oct->cores_crashed, true);
> +		module_firmware_crashed();
>  		other_oct =3D get_other_octeon_device(oct);
>  		if (other_oct)
>  			WRITE_ONCE(other_oct->cores_crashed, true);
> --
> 2.25.1

Thanks!

Reviewed-by: Derek Chickles <dchickles@marvell.com>

