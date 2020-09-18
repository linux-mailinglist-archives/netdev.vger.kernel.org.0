Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04EE26FF0C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgIRNq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:46:59 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:46115 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRNq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:46:57 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 09:46:56 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600436818; x=1631972818;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=VfC/V5xlPo9IzTW7DETv5uxkcCw6ETiVphtYRaPUW/xTU+C6x0+/hDVe
   I+dL/CjNJ9n5+I85TKoPSx0dhWdCF2LANV/pm6kAEB9AQpSEkMTWE0jzY
   hc7TTPLpNCOVD0IRf2l+nXwzS8r2zDuCf3Sl6mPr6h8lRn7CmAWoj7ArU
   F0zalqhMiyQh1yd6tFbN78ncDbIUUTIWYZTtZKZgXfacoITfP4/3gf7aR
   3Sn8qFJDFJPSKuzTY8alOqycSBhKdpXiX0pJKYzz5NPm1b96bqn6s84j4
   m9MO+VY6lL7Ps5AXa+FXGbF/8Ofdy0fgL8vu265Q5IZ/NtfA78AgHEyor
   Q==;
IronPort-SDR: vIeMwdqV3VNNKH7bvdxp5qvCFElvCEzBXSxc+rFYpZswmmDEyj4rmbXScYdfT1X/iwtFnDXJDA
 e55m5+7fR53FZTzTrjVSrLtrlqyXCZ8K8eKfwbmbq1ibgadyGwsMcwEA0ogwK1TKFVz8L8u36H
 4838heaIXWQci9ycpXpgx0JtFFg/F1malogKVCUw3ZDB+ZnYnRQW0KwYyOP/1z0CXzHgGQ//EY
 7b3zRF6/dI+2s80qxjAgzICYoFNvCuD/djtLAT1OG87jjSer9Eicdjx6WqhWA64/qsWcxgSeWg
 58s=
X-IronPort-AV: E=Sophos;i="5.77,274,1596470400"; 
   d="scan'208";a="152092455"
Received: from mail-co1nam04lp2055.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.55])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2020 21:39:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FuCwmeO4rpbH3VjKgXaEf4qpzWk6GdyyKgqC9uyIKDfg1I3Kql8ENy+uLotQ+XXLZucrn2JdJH+UPeDJC3WexoqcC/UTf5rxy/Uysx1tQU/Ha6WEdt4pZXYK4+wofb+ThzmIurQGvUgR8ita2Ks2a3pCOcVKpcQFfPsYxfCrlFYVWevAQjeXiPRaLgSe4DVmxYS4LwXR782EX0A74/69nQJgMzG26iZgd9I10PVJrNdlfES5KuCvoUiZBopK00/zQ7pBnKcvF2Z1fyKbTuCWHWreNLGqfVDR+I/bezEXRlk7kcJUUlkUOb3l0/1ZZHFQQTR0+jMVITHD0+SnYPhV/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=L7JGDg9SCFDWz7wodm09zPl2wqpo5QD3bdNL35QPXbqvY+W28NVYvLfJLqTAaLtA9MhWr9GmAVC4xDrH3nfngXLl5fWJoBp0mtkN5ddOYikjyKbPjL4hAxRZcIrsFVl5uXrtyjW+E/Adcz1y89dGaX9X+AL5oEvAdhjqy8sPxMNR0YLAkHPkiGTKnspYYilSrF6e2pwbikJHDclOZzwPtap8Yxd8BaH12kYMUW9U+Nl47ACRDqn0k8+Ehvc1rWRuX194cpdq8aJB1/K1ZltycOIQikq26fLFfubdxlc8+I5T6EdhyorbSsuJY2NZhDc/uLoURwRW8WQxsT4znayWSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=tUfofqpLKA3xYlk55fkFmbhM8yxwbThnW3vo4N5NqHAchUxpyAAGpd/fu6SSw3rgYjycp8cn5NImAlBZaoeNAkiO9W1AMbBB+x2lLASeGCL0q7QY/dOfcG06B4O+tUa7DMD8Md90BWyP3g02yUwJxOot3tB/9xL2EWzTstJPIEo=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3677.namprd04.prod.outlook.com
 (2603:10b6:803:45::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 18 Sep
 2020 13:39:46 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 13:39:46 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 3/9] fs: explicitly check for CHECK_IOVEC_ONLY in
 rw_copy_check_uvector
Thread-Topic: [PATCH 3/9] fs: explicitly check for CHECK_IOVEC_ONLY in
 rw_copy_check_uvector
Thread-Index: AQHWjbmt6fIBeaY/cUK8wURv0z7SLg==
Date:   Fri, 18 Sep 2020 13:39:46 +0000
Message-ID: <SN4PR0401MB3598A3419ADDE8CBEBF011D89B3F0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1460:3d01:8d9e:cb93:a2df:3de3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 225c589d-e123-4dd1-9c05-08d85bd84ee9
x-ms-traffictypediagnostic: SN4PR0401MB3677:
x-microsoft-antispam-prvs: <SN4PR0401MB3677905D948DAB3FAF7E9B3E9B3F0@SN4PR0401MB3677.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Pts8Ztsyn2UrRoufKPPkf1RDEy+4gqLt6hwM3dnltsZYj+Cwms0m9cO0REoefzWWFCW1vv2ExwIy/uapJC4QiZdL2bFL4xAy5N1E1EbxLUNeYiG0f3g/KGkM+WwmvxwdmbFuyQMkWeWMfUMcznmzXjLSfljItqlRkzjaQFm5UzWfCv3v/phDpknp/tVgVbwFyWTONIOagbpz1Fsx8kjklmUb3yi1bF+g6wdqHgNjls3Ip7k1hu6YBngHLNhUifxpnCFNZ87Xr4xm7NnnFP/TOYpgdIwkcrddlny3tzMI8dt8qlmprPyklq1s5tKDqpRivm+bTX3p2u/M1W4toDw2H3sGu7gR4Kk+b1SqGreLgfeeyXODjJalmh2PgYx1pv+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(6506007)(76116006)(66556008)(64756008)(558084003)(55016002)(8676002)(9686003)(4326008)(91956017)(66446008)(4270600006)(110136005)(54906003)(7696005)(19618925003)(316002)(66946007)(66476007)(33656002)(71200400001)(86362001)(2906002)(8936002)(52536014)(5660300002)(186003)(478600001)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CRJonTWzohX7//DS4fqazAMP3tn+lYrGVYwdjqTwW2NH6dFZdzo/oCX1b4p+46NhLdfZiPu0e9Kt+tnrvoMbY/5T6vYBZDk0cp9hIIliJf/c1ln2RPHF6rGHmDrZTU6NauXSfBJgXqNeo6LHwnLORmcvWCYp332yj+RDCwe0y3d0RTD1/8Z9UZGp8kxhOWagatoXCs5cSi77xB3Y/ajnUiF8n0ZrDCEvSK4cFghsnDtV463ja1pLB992pyxKXG52u/CkqRH6zaU72ix6sjsCZbRkw8vRyFLAQ2988lSUHa8rWzxUgNoyDdh3qIFAOODLWx5QFL7ncUpZx0ijMa4Fo7JVbH9YTBO6WixuJfcboPIIumuBVjHOBAg5swE2cghkoQFJxdZOyLQHIB6xhohnw3xRap9V41xhRO+IRLVHrCmixFZxbZ4wurqqtGvv8/6h6wJpp2uHRnkkILjeWPSVukqbCe6R9Q5mj5SG0kLxPjGYxBfrcgECJw+nSLqb2kGjUcuPFrfnAgWOwKgxP3YnVvu7uwKqDCJR6qHevRqqLWmf8CAlXVgVsx6k6pltD5olOS6VW6/0JA+sjpVfsPdN3UmE+3yYORkjpw/qvh15StHhiJGtSCriKmB7ENVdqJpNZassRq6Yv9BWJ1reHos8rZ9EBrqOmY/nRqSIQhAupxrvGjk7/UCtVJjndmXZeEmwEe7gwCvG2TavrUe3Ugeg5Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 225c589d-e123-4dd1-9c05-08d85bd84ee9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 13:39:46.5722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mRjEHWEd2f8a65Sb3qM7RhJrazg4VTLNE0IAXYGgomx8udg2TH+zeFrnLQuH7rhCgnh3wU1fvN1HnOcKyQ968KgHjiceOTspA0ghnwa792w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3677
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
