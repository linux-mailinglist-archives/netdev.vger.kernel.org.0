Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE30408690
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbhIMIcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:32:23 -0400
Received: from mail-bn8nam12on2052.outbound.protection.outlook.com ([40.107.237.52]:33696
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234575AbhIMIcV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:32:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uyc+tUgt7xPtzPLO/bAhZo6nxcFMQoGRpi3+RF9rdtgpYvT+SMv3VUP8yClC8AtV8uG+J61bqplwAHTnsoWSN4QaZBG7kXl4fjjJBqBcHXBX2Kp/0qy90qjhktnPD/kYwV52BT5V3prQSJSkCYplRGZFtPY7psKJ8/CqFseWp8u/75Uo0TRbs42OP+N/UOrYMnQIYIoqXkK+BIo7koViJfLS/bvriWVZexCBx2khnlyfbYoVpZj0EAmHxGNLrAAaxgUWD1isTLwugu00+PY3GXobhgn/2KYBJLbA9WlWscBNJV/HP5wW/YCSr11faMl/ex3+gJpGvpZ4y68vxKftoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SQNpjUe61SqKssYQU/Mb0PGzbkSpWdFzmsj0q0MhMz4=;
 b=cGmjKnBG4p0b1rNjnR5YnKY3MHKT6PPnVXIUU4WF61XirokLcyKQZe8P3yWnmHUIjbrBz6fXbiPdoiMkt9THTQKzOXHjwOCteswW9NBLHqi3NIkPqxuQdVePPVib6YfcnrhQMs513LpMoO7LAbEAGtVmCMy2kC+d8G+X4tiP5Y0qciVSkW19Du3zNgJVtNISsTAVIdXQ4k2xEMQ9GiI0wbSf4FliIZyMDk4rHCrLzGzVguiFmYELks5nyvPTQkc79rQFvkxrzXDx0rQlZS2sE4JicqaFpb2cwxWAsxBi5i1DXW3rj9xHhW9wQD3vcCjXPpb/CS0jSwBwxHnLRdbqDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQNpjUe61SqKssYQU/Mb0PGzbkSpWdFzmsj0q0MhMz4=;
 b=bO4WIRHAR1jlBV4hlNTZYz0qaJD6U/Z+A/trkwaUh/k5iCeHDr7pcjIHRTd7emeMZ3i9ZDq+vKnU7XHSkwF3K1NgGV6JU54a5ONey/34I0KB4TYqnY+67GEXaYjC5PF7jg+D7Kk7pGSLnmPK4RHwJlJONLzzhNe9gY+UheecjTU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:04 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:03 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 00/33] staging/wfx: usual maintenance
Date:   Mon, 13 Sep 2021 10:30:12 +0200
Message-Id: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7475c927-a116-4016-6e5e-08d97690d2f0
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB32637D0F8DCCF05D8FB5678293D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i3Pl2unxpaC2Z/vzDUYQov8SLn67OwckZj3nIyESgRWKNi51RWZGBVPIhW3zvHz4m0bjjCEZAKKroZce+FAue5hcifLfEKDnzRF6M9hZUAKoIhRgZo8Hs1GBkk3xghRyssH8CnHKDU5Wri/9FVHsGK/5nNNyDLmqhX4pIHj8sVqeIDcB1Iq+idqALACzlzbktw2c+g8HeVa4098cAyJ1Gf/c26KoHFWFzMEe9wOC6lMUCVzvzHSc77OS6luWCs06JoxUFxLG/F0l70nU6zS1F8GQJ1/hby1SDOhDdXNpCdVB+Y9xaYTDUVon1UVQxFAwlMgjYh2OhJW7pB210E79cmAveV8t4omPXxsxFc4zg8hKir8PYDyEu012tuEtEgcLfAPS1JSxE5Ccck4N9PO2exRRX61WerFyOIfg3yniXyZcregDRP7tycvZJw/onCRQcexYUXatGmTHYXNE3xaBseTf8Ei2rO//VG5FoN4lxqgxewg6Ar5a5tVgDASwSUj3isIL4CBETIrq8gmxI65G2PwDz0pJcLCFGXqxDKshbETTY9avVJt4dQ0GBNjn28KzyimCAchFQ6Gy0UUVqiV+iOJBmH4uA5VI0YWrjDsykcW4voFXoXXle8YaZX+yKiJ4JDHMXqavJKc3C7uxXAC0YbHf0G5cPtKN18owzqS0Sx0YO4P70coSmfGwZjVqaZXbJZoa2ont55h2WseWaTEneiG3cVN3HCEWFfE+263LU7lqmNUXTKuVaKrp3iVBI6Ufrplnh3CvEi5x/JK8KmmornZHEySOLIubAne/ITFZLF0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66574015)(966005)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(6666004)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0ZMYW5aOGxseXBqTUJPRmloQTJxTW15NnlvSTBXejBVbzlST0ZueVE5cnZB?=
 =?utf-8?B?cXlhYzBuQzA4SFFsOWRZQTlTYmthK1RmSi82SW9QUHU0MGE5YXc1RzUrV3dm?=
 =?utf-8?B?eUdaY1ZjY21KaVczYzBBWFFhaEFXV1ZENkpjSlpGaFFFWjhtakxQS3RUb0VR?=
 =?utf-8?B?ZEFBQmhqL0orK0JwQkxQN1E2VmNNcFA5bk9SSnBVb2dzWEVKUE50WEVmbFQ5?=
 =?utf-8?B?emNTOUs3T0RJRmNEbWt1RndrQVRZNmdtRVltSWE5UTc4TExGK1ZvZFh1RVhP?=
 =?utf-8?B?QTEzMUNyYlIrSWxuYWdVaEtuOXkxd25LQk5jeTJEYU1mUWM5VlEvTDlrMU00?=
 =?utf-8?B?TmM0aXJGR0FGeUN3RVk2QVcvUFNOT2FMR2lmTkJUcndpQkg2VkpwSUFubHRm?=
 =?utf-8?B?dU9mVUQ5VTNQazJ6czFiMjZoSjY3Wm1OQ1pQRWlyTk5EWGUwY0VZcVZXby81?=
 =?utf-8?B?ckZNN0lkdlErcmltWlVMY3pBZTFDMGhobWJ0SDMvTXNhSldQSWxLYWJsbkI2?=
 =?utf-8?B?cVFneFVyUDNzU2FuQlloR1RRaEQrRXVjNTFaL294YnE2Q3I3L1N2NFVZdHlW?=
 =?utf-8?B?ZzNmeEtZZUpzTktHZitLSmc3THV5cnFMZEpXdmgwUTFBOTF4SDZySk41RjZ3?=
 =?utf-8?B?V0FIUDlVdllUaEVDR28xRnBnT1JzcXJ4TmI2SW1rMWhkN0M1OU4vSVV1S2VQ?=
 =?utf-8?B?eDZtWUtEMjFxcTlZZzBLZ2hOY01mM0lqWnF1dUZvM09nUDcyUStWM3E4a1p2?=
 =?utf-8?B?UU5jWDdUa0haYldjajNKeW9QbkU0SmFkWlExazYrYkhCcEQ3aHE2cy95dEc5?=
 =?utf-8?B?UU8rOEhraW5WWWdMcFhBUXVrbm9sbnNpTGorZ0tZWEtIUkNFSjY4OGY5SEFS?=
 =?utf-8?B?cGhzRnVBbkFRNCs2MXFhekhSaHRRQnRlQnhVSWprUytyQmE0a1AycDRzbnR2?=
 =?utf-8?B?VFZPNGkwWWZYZ08rTk5BSXM5aUlGWHJtTkw1RFh0MkNVdGgrRVpCbDgzNjVT?=
 =?utf-8?B?Vld6TFJSbCtYUmxVcVh6SHlSNTRqN2t3MURjRno0cWU5eW1GZFQ4S0hQMEtY?=
 =?utf-8?B?S0NrUlNCdUNNSEVIaFlHdUdTamRuVUdWZFo5bUNiVEJxRWtpTjljNC9sWUxH?=
 =?utf-8?B?VkJnV3p3bm5vVzVMS21XamFEdFd2Y0pzNDdjUDZhd3ZBb3NUd1hZVTdpdXVr?=
 =?utf-8?B?Y2dHVGZKMnEyc00zdE1wZ2tTZHE1MFdpMEZVU3pqNjJZZytqMzBtR0t3bjdl?=
 =?utf-8?B?RnBUUVBiRUdZNXFabVI3V3RCWUJRcGVWMXZGdnZGaVBJbTdMVEZ5MUREck9k?=
 =?utf-8?B?MFNwblZvNjROd01wdm8zSGwxM2VkcDYvb3FQaURRNTMwMEFHTUc2emdvci9l?=
 =?utf-8?B?Q1ZNWkROZW5ydHh0YWg1NlA5aC8rNW5IemZiNnI2QW8yR0pFU1U3OWJWVFli?=
 =?utf-8?B?aGVrSkM4bTBQQnAzb3dqc3FIQlhmU2oybzd4QWNkalh3VHhvTzV0cjdBM2Yy?=
 =?utf-8?B?VnZ6T21UVnFyNS94aGxmdkZDeGc0OWtteVRGZ09lZEtFYXQ5dE13SUFrd21K?=
 =?utf-8?B?R0NvOERZTHFYUkxjTU4vNUZUd1lzRFR5SnMrVjhIUWZQVm43UzZualk3c2dB?=
 =?utf-8?B?ZytLc3h4ZzZpY0lFQ3J3UkV2OCtCbEdmbEFjeldBOHpQd01XQUlGZjBUcnFi?=
 =?utf-8?B?Z2hTcVNuRXBsVmJ2WWlERno2R3FtYlppaVBBaStNdnh4UVFoWjJnWjNpRnBV?=
 =?utf-8?Q?h7FCaeYz9D9HUlfx07PwlZhUrwC1iPkkG8psL3f?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7475c927-a116-4016-6e5e-08d97690d2f0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:03.8175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: loNGDGrz4gA2krM0wOinIU6AGGEwOFJ3n82hnGtCt2bEaB3Nd81t5jZ72nxebMH93eT1amFTuYVVs3mAEUXpcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGks
CgpUaGUgZm9sbG93aW5nIFBSIGNvbnRhaW5zIG5vdyB1c3VhbCBtYWludGVuYW5jZSBmb3IgdGhl
IHdmeCBkcml2ZXIuIEkgaGF2ZQptb3JlLW9yLWxlc3Mgc29ydGVkIHRoZSBwYXRjaGVzIGJ5IGlt
cG9ydGFuY2U6CiAgICAtIHRoZSBmaXJzdCBvbmVzIGFuZCB0aGUgdHdvIGxhc3Qgb25lcyBhcmUg
Zml4ZXMgZm9yIGEgZmV3IGNvcm5lci1jYXNlcwogICAgICByZXBvcnRlZCBieSB1c2VycwogICAg
LSB0aGUgcGF0Y2hlcyA5IGFuZCAxMCBhZGQgc3VwcG9ydCBmb3IgQ1NBIGFuZCBURExTCiAgICAt
IHRoZW4gdGhlIGVuZCBvZiB0aGUgc2VyaWVzIGlzIG1vc3RseSBjb3NtZXRpY3MgYW5kIG5pdHBp
Y2tpbmcKCkkgaGF2ZSB3YWl0IGxvbmdlciB0aGFuIEkgaW5pdGlhbGx5IHdhbnRlZCBiZWZvcmUg
dG8gc2VuZCB0aGlzIFBSLiBJdCBpcwpiZWNhdXNlIGRpZG4ndCB3YW50IHRvIGNvbmZsaWN0IHdp
dGggdGhlIFBSIGN1cnJlbnRseSBpbiByZXZpZXdbMV0gdG8KcmVsb2NhdGUgdGhpcyBkcml2ZXIg
aW50byB0aGUgbWFpbiB0cmVlLiBIb3dldmVyLCB0aGlzIFBSIHN0YXJ0ZWQgdG8gYmUKdmVyeSBs
YXJnZSBhbmQgbm90aGluZyBzZWVtcyB0byBtb3ZlIG9uIG1haW4tdHJlZSBzaWRlIHNvIEkgZGVj
aWRlZCB0byBub3QKd2FpdCBsb25nZXIuCgpLYWxsZSwgSSBhbSBnb2luZyB0byBzZW5kIGEgbmV3
IHZlcnNpb24gb2YgWzFdIGFzIHNvb24gYXMgdGhpcyBQUiB3aWxsIGJlCmFjY2VwdGVkLiBJIGhv
cGUgeW91IHdpbGwgaGF2ZSB0aW1lIHRvIHJldmlldyBpdCBvbmUgZGF5IDotKS4KClsxXSBodHRw
czovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMTAzMTUxMzI1MDEuNDQxNjgxLTEtSmVyb21lLlBv
dWlsbGVyQHNpbGFicy5jb20vCgp2MjoKICAtIEFkZCBwYXRjaGVzIDMyIGFuZCAzMyB0byBzb2x2
ZSBhIHBvc3NpYmxlIHJhY2Ugd2hlbiBkZXZpY2UgaXMKICAgIG1pc2NvbmZpZ3VyZWQKICAtIEZp
eCBDOTkgY29tbWVudHMgKEthcmkpCiAgLSBSZXBsYWNlICJBUEkgMy44IiBieSAiZmlybXdhcmUg
QVBJIDMuOCIgKEthcmkpCiAgLSBGaXggd29yZGluZyAiYWxpZ25lZCB3aXRoIGZpcnN0IGFyZ3Vt
ZW50IiBpbnN0ZWFkIG9mICJhbGlnbmVkIHdpdGgKICAgIG9wZW5pbmcgcGFyZW50aGVzaXMiCgpK
w6lyw7RtZSBQb3VpbGxlciAoMzMpOgogIHN0YWdpbmc6IHdmeDogdXNlIGFiYnJldmlhdGVkIG1l
c3NhZ2UgZm9yICJpbmNvcnJlY3Qgc2VxdWVuY2UiCiAgc3RhZ2luZzogd2Z4OiBkbyBub3Qgc2Vu
ZCBDQUIgd2hpbGUgc2Nhbm5pbmcKICBzdGFnaW5nOiB3Zng6IGlnbm9yZSBQUyB3aGVuIFNUQS9B
UCBzaGFyZSBzYW1lIGNoYW5uZWwKICBzdGFnaW5nOiB3Zng6IHdhaXQgZm9yIFNDQU5fQ01QTCBh
ZnRlciBhIFNDQU5fU1RPUAogIHN0YWdpbmc6IHdmeDogYXZvaWQgcG9zc2libGUgbG9jay11cCBk
dXJpbmcgc2NhbgogIHN0YWdpbmc6IHdmeDogZHJvcCB1bnVzZWQgYXJndW1lbnQgZnJvbSBoaWZf
c2NhbigpCiAgc3RhZ2luZzogd2Z4OiBmaXggYXRvbWljIGFjY2Vzc2VzIGluIHdmeF90eF9xdWV1
ZV9lbXB0eSgpCiAgc3RhZ2luZzogd2Z4OiB0YWtlIGFkdmFudGFnZSBvZiB3ZnhfdHhfcXVldWVf
ZW1wdHkoKQogIHN0YWdpbmc6IHdmeDogZGVjbGFyZSBzdXBwb3J0IGZvciBURExTCiAgc3RhZ2lu
Zzogd2Z4OiBmaXggc3VwcG9ydCBmb3IgQ1NBCiAgc3RhZ2luZzogd2Z4OiByZWxheCB0aGUgUERT
IGV4aXN0ZW5jZSBjb25zdHJhaW50CiAgc3RhZ2luZzogd2Z4OiBzaW1wbGlmeSBBUEkgY29oZXJl
bmN5IGNoZWNrCiAgc3RhZ2luZzogd2Z4OiB1cGRhdGUgd2l0aCB0aGUgZmlybXdhcmUgQVBJIDMu
OAogIHN0YWdpbmc6IHdmeDogdW5pZm9ybWl6ZSBjb3VudGVyIG5hbWVzCiAgc3RhZ2luZzogd2Z4
OiBmaXggbWlzbGVhZGluZyAncmF0ZV9pZCcgdXNhZ2UKICBzdGFnaW5nOiB3Zng6IGRlY2xhcmUg
dmFyaWFibGVzIGF0IGJlZ2lubmluZyBvZiBmdW5jdGlvbnMKICBzdGFnaW5nOiB3Zng6IHNpbXBs
aWZ5IGhpZl9qb2luKCkKICBzdGFnaW5nOiB3Zng6IHJlb3JkZXIgZnVuY3Rpb24gZm9yIHNsaWdo
dGx5IGJldHRlciBleWUgY2FuZHkKICBzdGFnaW5nOiB3Zng6IGZpeCBlcnJvciBuYW1lcwogIHN0
YWdpbmc6IHdmeDogYXBwbHkgbmFtaW5nIHJ1bGVzIGluIGhpZl90eF9taWIuYwogIHN0YWdpbmc6
IHdmeDogcmVtb3ZlIHVudXNlZCBkZWZpbml0aW9uCiAgc3RhZ2luZzogd2Z4OiByZW1vdmUgdXNl
bGVzcyBkZWJ1ZyBzdGF0ZW1lbnQKICBzdGFnaW5nOiB3Zng6IGZpeCBzcGFjZSBhZnRlciBjYXN0
IG9wZXJhdG9yCiAgc3RhZ2luZzogd2Z4OiByZW1vdmUgcmVmZXJlbmNlcyB0byBXRnh4eCBpbiBj
b21tZW50cwogIHN0YWdpbmc6IHdmeDogdXBkYXRlIGZpbGVzIGRlc2NyaXB0aW9ucwogIHN0YWdp
bmc6IHdmeDogcmVmb3JtYXQgY29tbWVudAogIHN0YWdpbmc6IHdmeDogYXZvaWQgYzk5IGNvbW1l
bnRzCiAgc3RhZ2luZzogd2Z4OiBmaXggY29tbWVudHMgc3R5bGVzCiAgc3RhZ2luZzogd2Z4OiBy
ZW1vdmUgdXNlbGVzcyBjb21tZW50cyBhZnRlciAjZW5kaWYKICBzdGFnaW5nOiB3Zng6IGV4cGxh
aW4gdGhlIHB1cnBvc2Ugb2Ygd2Z4X3NlbmRfcGRzKCkKICBzdGFnaW5nOiB3Zng6IGluZGVudCBm
dW5jdGlvbnMgYXJndW1lbnRzCiAgc3RhZ2luZzogd2Z4OiBlbnN1cmUgSVJRIGlzIHJlYWR5IGJl
Zm9yZSBlbmFibGluZyBpdAogIHN0YWdpbmc6IHdmeDogZWFybHkgZXhpdCBvZiBQRFMgaXMgbm90
IGNvcnJlY3QKCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2JoLmMgICAgICAgICAgICAgIHwgIDMzICsr
Ky0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvYmguaCAgICAgICAgICAgICAgfCAgIDQgKy0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYyAgICAgICAgfCAgMjkgKysrLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L2J1c19zcGkuYyAgICAgICAgIHwgIDIyICsrLS0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfcnguYyAgICAgICAgIHwgICA3ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2Rh
dGFfcnguaCAgICAgICAgIHwgICA0ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyAg
ICAgICAgIHwgIDg3ICsrKysrKysrKy0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFf
dHguaCAgICAgICAgIHwgICA2ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmMgICAgICAg
ICAgIHwgIDU0ICsrKysrKy0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmggICAgICAg
ICAgIHwgICAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uYyAgICAgICAgICAgIHwgIDI2
ICsrLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2Z3aW8uaCAgICAgICAgICAgIHwgICAyICstCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggICAgIHwgIDE0ICstLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaCB8ICAyNSArKy0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfYXBpX21pYi5oICAgICB8ICA4NSArKysrKysrKy0tLS0tLS0tCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl9yeC5jICAgICAgICAgIHwgIDIzICsrLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl9yeC5oICAgICAgICAgIHwgICAzICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eC5jICAgICAgICAgIHwgIDYxICsrKysrLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
dHguaCAgICAgICAgICB8ICAgNiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMg
ICAgICB8ICAxNCArLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oICAgICAgfCAg
IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaHdpby5jICAgICAgICAgICAgfCAgIDYgKy0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvaHdpby5oICAgICAgICAgICAgfCAgMjAgKystLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9rZXkuYyAgICAgICAgICAgICB8ICAzMCArKystLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93Zngva2V5LmggICAgICAgICAgICAgfCAgIDQgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvbWFp
bi5jICAgICAgICAgICAgfCAgMzcgKysrKystLQogZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmgg
ICAgICAgICAgICB8ICAgMyArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jICAgICAgICAg
ICB8ICA0MyArKysrLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAgICAgICAgICB8
ICAgNiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgICAgICAgICAgICB8ICA1NSArKysr
KysrLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmggICAgICAgICAgICB8ICAgNCArLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgICAgICAgICB8IDEzNSArKysrKysrKysrKysr
KystLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaCAgICAgICAgICAgICB8ICAg
OCArLQogZHJpdmVycy9zdGFnaW5nL3dmeC90cmFjZXMuaCAgICAgICAgICB8ICAgMiArLQogZHJp
dmVycy9zdGFnaW5nL3dmeC93ZnguaCAgICAgICAgICAgICB8ICAxNCArKy0KIDM1IGZpbGVzIGNo
YW5nZWQsIDQ2OSBpbnNlcnRpb25zKCspLCA0MDcgZGVsZXRpb25zKC0pCgotLSAKMi4zMy4wCgo=
