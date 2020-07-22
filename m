Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EE8229AE5
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732798AbgGVPA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:00:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13780 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730465AbgGVPAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:00:25 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MEmk7P012167;
        Wed, 22 Jul 2020 08:00:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=N9sM/rax6qcAio4WppyrBpzY7VSKK9ffMiYkuBPlkkM=;
 b=QzpCPRXhJDiC8rYDx593hgsdnQtJC86vncF/uqUk5Jqp8WpNxvY6T8W5TGWjugcvh2h9
 CVzo92TfoX0KwAEjZ71wFT0cVp0eR7WwaJVOcyMCGFzRIHyFl23HziJmZcPjVuDma/bH
 6KUurniQy5ATWjU8LWxaxDmhTUEP7Rm3ddpWm67pn97riryqn/1DjRELgYpTqR+IY5Jj
 EcohMt3heFzLbfC6XwXdv5bKtWZNT2ang1KKN0K434nQ/Grdr5y0e46NAIsNW4CZZj+C
 if56PPHVEhRF6FnXyWAqpjfnCTQLp7c9imGMZyDBs3LU0e10L8wV/PvavaiFdu/h2DhU rg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkrc16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 08:00:00 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 07:59:58 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 07:59:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 07:59:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftSkVlWRlLrM8Vucky8Lcl8ahpZaW/CrwrFVWkJyIfktkZ3f57i4huILWPIEa/UtHI10pEtvMjxUItk0oM3mF5zcp1KqZKaNpCmOmWO2JEoQRWdA07vyF80LLj8WPBL0ZpfyOniRFwOGqUfL5RMHOK25TKoZiEFqIYD4DYkYxbRCTBstmLjvspGozadLlOQThsKg5uM61IZZKgxtdD0Gt2IxwGX8FZDrJP0bJ+XfHGJ7ftXEgpaHjB5bbgo4n4KqtK7RlH3gTogsxThszwMkk8AVr7VIGXRjxJR0EUW0hvoEs+DqFgReCS6UgBfY92p5laEZqmDEMN96eY2knqvh1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9sM/rax6qcAio4WppyrBpzY7VSKK9ffMiYkuBPlkkM=;
 b=fhjzBUJPskdVX0N0k+YVL3vUzxOsP5B0GoZf0lG3OoDd+BhogS/RnaeE4KdLC+H+IHNzjVpe86We0Ev+r36URyxw5YOTokvoWxCa9cGT8ZiUFKViEB/pJK/jeMz8gLMHzkMo6bpbFBlZesCnQsOHVBfFxWd5QafcVi0DFH8zchYj2lh4gU6zv+Qmc+NeUqbNVz5sxQt553kDrcKK+stJAaU5Ny19StslbXFRW+vUz2qoqMa8LLVK/bLQ9yzPBRdpKwS4JDAbIr9V5FwuUbmPOcn9Af1x3TOyvRgV95DSQNrNXxCP4+j3L9laiZ11mQFUdmI/THf5DTPIJwb6OZtkWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9sM/rax6qcAio4WppyrBpzY7VSKK9ffMiYkuBPlkkM=;
 b=aNdc7BCH3bXSCX3R4GojVhj7I8VQiaQDwzHQkGXo6ICK5NhBNlZyEIJOVoQ0jcOKLBDS6ll+qc4jW8MWsV7E2j83MCnwTGheDxXWcWGE6jWeafD6hvxDF63D0qSGYugZxsdwJ+2VUsPDWxowT0qhF7v4I0UQcKQumqZv192Zp+g=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR18MB1517.namprd18.prod.outlook.com (2603:10b6:300:cd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Wed, 22 Jul
 2020 14:59:55 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 14:59:55 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH 13/13] task_isolation: kick_all_cpus_sync: don't kick isolated
 cpus
Thread-Topic: [PATCH 13/13] task_isolation: kick_all_cpus_sync: don't kick
 isolated cpus
Thread-Index: AQHWYDjCVLK1C7iHf0mh+9tcFOIgtg==
Date:   Wed, 22 Jul 2020 14:59:55 +0000
Message-ID: <5d0088ffd762b266124dfa5da9bcef0d9ddbae96.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
In-Reply-To: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e867496-af1e-4a15-573e-08d82e4fe52a
x-ms-traffictypediagnostic: MWHPR18MB1517:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB151748F135B88491922384C7BC790@MWHPR18MB1517.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4ZK13hBho0PjC9DJmS/KBDt/6ebv9zXgnck8/c9Llq5vUeaNi4uDTHQdgsljkxu1GkAbfYcK6Ri/rXOTWDytCj8ve3hdReuTh1Fho4DqkYKmlTVEbwGVUalNDxwMV+sHE9uTCpAm92lzqX05Tsh3LnFlk47k06mH4SS+PA46X9c90bSfQ+EFsnpOaJcvmTgpsIhUPmAGHxpvzJq+lJGiHTc8Er771wU+EDlbNUnpqQx7KUBIpuRAsmhbGwoQVYDWomwKZg3A0Chq/axcFYiYy3D3CXnNc5qX2lNeHynIgcK9kCIH/ORe2T8kUDpjiGbT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(83380400001)(316002)(6512007)(7416002)(478600001)(66476007)(6506007)(6486002)(66446008)(64756008)(66556008)(8936002)(26005)(66946007)(5660300002)(2616005)(36756003)(71200400001)(8676002)(76116006)(91956017)(4326008)(110136005)(54906003)(2906002)(186003)(86362001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Np0Fwdd8jv1fxTSsx3MwsF69FPbUpsSOKKMrW+n/wr+2jk44eHPHPZACNYS/eHAmXhFCTluXLhW9nEumiVd8/Ae/9snwf0KsjfMcEl5bwOY8TL5k3zEV2rX46xWRcfJ2kLev4OQofpA2WJ6uV6out9vQCaVU7TPmgVUrrQJvU2C6kYlpme6mFRZK8+ogHHEEeyiVa+Pi/pKYo8xEgxlQFko1duhwIyuRpG1+x2kWsjsFeuNu46vmnlCO5fVOx5EG91SITZjsmLiSwkCsw8kU7lpp4i6qzOeq/4cHuyRbt5KFlilzIwdPUXKQuTmMkIsFhmlRVsAc1ATR0N8GnvGelFmqFKDNX/Zkaxp8mm5OV5fQTb3zSAmRWgCpT5gSseJ5hZ39LdXmD0RPS/PXsr+Gi5gBPKJBggyZ1W6PPAmnCdsUT7N0zoRsFxZElbn6kzK1BOhJIqUkUXSoT6f5F/wzmWE5OVhbUXb+Xa0TKV/SDf1cewexPaLXZQrPZqYmR70E
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BED713CFA78E1408C46F0C24DF285EE@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e867496-af1e-4a15-573e-08d82e4fe52a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 14:59:55.3607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rbwq8hvU6DJjX9uMARKpktL7Ahhhm6+UuFQSQHRXsBBM1taU87vvBcP+7YdgrQcsSeVhTKsjdmZ2sB3fW8cq/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1517
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_08:2020-07-22,2020-07-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KDQpNYWtlIHN1cmUgdGhhdCBr
aWNrX2FsbF9jcHVzX3N5bmMoKSBkb2VzIG5vdCBjYWxsIENQVXMgdGhhdCBhcmUgcnVubmluZw0K
aXNvbGF0ZWQgdGFza3MuDQoNClNpZ25lZC1vZmYtYnk6IFl1cmkgTm9yb3YgPHlub3JvdkBtYXJ2
ZWxsLmNvbT4NClthYmVsaXRzQG1hcnZlbGwuY29tOiB1c2Ugc2FmZSB0YXNrX2lzb2xhdGlvbl9j
cHVtYXNrKCkgaW1wbGVtZW50YXRpb25dDQpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbGl0cyA8YWJl
bGl0c0BtYXJ2ZWxsLmNvbT4NCi0tLQ0KIGtlcm5lbC9zbXAuYyB8IDE0ICsrKysrKysrKysrKyst
DQogMSBmaWxlIGNoYW5nZWQsIDEzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlm
ZiAtLWdpdCBhL2tlcm5lbC9zbXAuYyBiL2tlcm5lbC9zbXAuYw0KaW5kZXggNmE2ODQ5NzgzOTQ4
Li5mZjBkOTVkYjMzYjMgMTAwNjQ0DQotLS0gYS9rZXJuZWwvc21wLmMNCisrKyBiL2tlcm5lbC9z
bXAuYw0KQEAgLTgwMyw5ICs4MDMsMjEgQEAgc3RhdGljIHZvaWQgZG9fbm90aGluZyh2b2lkICp1
bnVzZWQpDQogICovDQogdm9pZCBraWNrX2FsbF9jcHVzX3N5bmModm9pZCkNCiB7DQorCXN0cnVj
dCBjcHVtYXNrIG1hc2s7DQorDQogCS8qIE1ha2Ugc3VyZSB0aGUgY2hhbmdlIGlzIHZpc2libGUg
YmVmb3JlIHdlIGtpY2sgdGhlIGNwdXMgKi8NCiAJc21wX21iKCk7DQotCXNtcF9jYWxsX2Z1bmN0
aW9uKGRvX25vdGhpbmcsIE5VTEwsIDEpOw0KKw0KKwlwcmVlbXB0X2Rpc2FibGUoKTsNCisjaWZk
ZWYgQ09ORklHX1RBU0tfSVNPTEFUSU9ODQorCWNwdW1hc2tfY2xlYXIoJm1hc2spOw0KKwl0YXNr
X2lzb2xhdGlvbl9jcHVtYXNrKCZtYXNrKTsNCisJY3B1bWFza19jb21wbGVtZW50KCZtYXNrLCAm
bWFzayk7DQorI2Vsc2UNCisJY3B1bWFza19zZXRhbGwoJm1hc2spOw0KKyNlbmRpZg0KKwlzbXBf
Y2FsbF9mdW5jdGlvbl9tYW55KCZtYXNrLCBkb19ub3RoaW5nLCBOVUxMLCAxKTsNCisJcHJlZW1w
dF9lbmFibGUoKTsNCiB9DQogRVhQT1JUX1NZTUJPTF9HUEwoa2lja19hbGxfY3B1c19zeW5jKTsN
CiANCi0tIA0KMi4yNi4yDQoNCg==
