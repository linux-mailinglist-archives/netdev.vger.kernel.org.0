Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411C741275A
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 22:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhITUgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 16:36:23 -0400
Received: from mx07-001d1705.pphosted.com ([185.132.183.11]:47930 "EHLO
        mx07-001d1705.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232098AbhITUeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 16:34:22 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2021 16:34:21 EDT
Received: from pps.filterd (m0209327.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KK4gJ0015896;
        Mon, 20 Sep 2021 20:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=S1; bh=FKD1zECKl2M+gxJ62DfaTKRPAnRDXKJEFWTBrHUpwQY=;
 b=boU5S7zw2dxyvKFyu12amVb+9bz+SFH2NLcztHn4RukF8+LpgM4CbZOVAPJoDlwG1FNS
 6Uonq4TU7uuJShv+E7EHqIYutCExgwS9Ek81wHJhqgAKYoUPEw+GBnO9C3i+jj4V+RMq
 B2eC/NwOdVBmEzbDtCr9sXcxCFxlYRKKY50vAtzRZi+siIHhilwfZrVKee+fhnSaHd6X
 jVriiJeqGFF4Q6dgRjNkPno6bSoHZHhOIHSODKOMx6dqUvOxveoZOIFbwtLM4frtLA9l
 RJJSGFixxc1mQwgcugYTM3JRclz69jPhMvey4L8av5ffVFIU0bDJUNpFhphrSQLki/Bo jA== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by mx08-001d1705.pphosted.com with ESMTP id 3b5701193c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 20:22:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OA3WYtiDvS0v7mDlR+KVnMNTnPF1eAk2t0nEz2L3iMwLLax1mCEpp0emJX0FX44BPAsZHSB6OUKF+rrycHZb5kgcET2cxM/INQr0XvLFi5QpEDJLw+nkfUWXU1mEK1eYw7yTow71seb1Z/vjIGXPi1JS4alEvZ8gT4VW77vr0aC/C+apBVIdDb7CU5fTbRq0+yBtulJWY31xheE1Rkb7GljdDCe2yxERr3g8M2cyVX1O1UazSPdALO5qzCK7+9JvxzYWTmgTV+SrxhGYiazOsSd+C9KCsdWDhN/6mJk/Zoqi0J6dkkaJEFk9xzcj9KxGpfQYrJkbNidRn6wXjge2Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FKD1zECKl2M+gxJ62DfaTKRPAnRDXKJEFWTBrHUpwQY=;
 b=DgxqyEiqt/qG02eDc3G2VNRsFPnQCh8y8J/hqN+jbDQLiXMv+7KPomMlGke+Lg7+sNgQmttKW/g4Xv0tsw3HfqmtQ7evTeGbFavirt4nSakUHOArRlkPeXzjn67G228b/NtvUQSHrfUI/ce2F1m/sIt0pu6DvMkEjtI2KJ6MuSkjIVo+wBrqF71bV1gnDTzHdJ/S7czjVyvty3Xcd2fpxdTFFXgJoClER/hi8X1HNUx+NygKemtrasFIPzS/aC0uS362/q9FlRxIupVRUEWDwBsGKoBqT01ayy/33/Ccd+vmp/o+5by7XC6dxjp7aXAuZUvK11Dcem022r4yKGkT6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from BY5PR13MB3604.namprd13.prod.outlook.com (2603:10b6:a03:1a6::30)
 by BY3PR13MB5012.namprd13.prod.outlook.com (2603:10b6:a03:364::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6; Mon, 20 Sep
 2021 20:22:45 +0000
Received: from BY5PR13MB3604.namprd13.prod.outlook.com
 ([fe80::44c2:dbfb:2fd6:c0a8]) by BY5PR13MB3604.namprd13.prod.outlook.com
 ([fe80::44c2:dbfb:2fd6:c0a8%3]) with mapi id 15.20.4544.013; Mon, 20 Sep 2021
 20:22:45 +0000
From:   <Patrick.Mclean@sony.com>
To:     <stable@vger.kernel.org>
CC:     <regressions@lists.linux.dev>, <ayal@nvidia.com>,
        <saeedm@nvidia.com>, <netdev@vger.kernel.org>, <leonro@nvidia.com>,
        <Aaron.U'ren@sony.com>, <Russell.Brown@sony.com>,
        <Victor.Payno@sony.com>
Subject: mlx5_core 5.10 stable series regression starting at 5.10.65
Thread-Topic: mlx5_core 5.10 stable series regression starting at 5.10.65
Thread-Index: AQHXrko8xYvrC7NN7Uiktm3q1KSJXA==
Date:   Mon, 20 Sep 2021 20:22:44 +0000
Message-ID: <BY5PR13MB3604D3031E984CA34A57B7C9EEA09@BY5PR13MB3604.namprd13.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 6b5cf675-83f8-f088-fec5-e6fddb593037
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=sony.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a1170cc-2e76-4e1a-894b-08d97c7467e7
x-ms-traffictypediagnostic: BY3PR13MB5012:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY3PR13MB501297FD5607EE152A6F2435EEA09@BY3PR13MB5012.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:147;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ekl8/PZar9V1zXOMu2fDEXB4pL7Z5Fp97/MGnZUvk+c76dSOpYa0TtZJGTs9Um7ahhrtqPUZWLY/5U3lg+fi5ShSmB923zXCFV3UM2OXu9JyNnUqv6rZxswkWO6Cp6CrIxmRgog8wCJE3SqtXbbszorurDqXYuPcq5X/yuhd6Qu809NQUnYVNKuRd3p0RoS5p+OmKw/uBdJKmnSGDiuYQRWkrpyWC+vH8iT0dtO92HfmUroQI/E4RJZtE1D8/7if6E7G1OlOnFcUIsYMvquQkg91gb64t/UQUypE0N3q7hQJgwfUz2YjaVLk+Y/vnyCjukF5ZQ9NRc+Fy9mvCl/P0JZ39JXSupdi/T37/yZDU/M9xPc6xnC3dtJDDkW2WIvYpuzC4M70KilW+TTpFpXoi8cZTrPTkOT94/pRNUzYGrzIg6v/ztsdieJD3U5LU5/cHb9Rt1waaVzF/eznFo9WcIauEnzCHm0zBndfTAKRD3exgbMfgQLb9hRJjS3u+YWRirA1tr/+LE4wL8h17Z7I/cr1ry8y9tRJpoy29rlreHhyO9FoVY4SwWiNupWu8PoZZnCGy4ESsH7JA2YI875blmQri9sCGNualEMQnFK2cff1YuuwHEluqsYkTXOMOOcD+QIONBiVO4s6T3z2f1ARL1zPukAm0dmHI4p7g76XVluz/BMRCSGkDU9dTOLQDrXq2qSBgF7UlvSUJ4emm+k7b1oPyHNxa76D1FBq/vJBE9YIASNSQcfWq2r6yzlALiECyfiK3+4J+AuD0lz5TFRMh5KdTGS1vRrswv01qt+uNbA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR13MB3604.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(2906002)(5660300002)(76116006)(64756008)(66446008)(66556008)(6506007)(83380400001)(107886003)(966005)(8676002)(38100700002)(66476007)(66946007)(7696005)(122000001)(55016002)(186003)(86362001)(71200400001)(54906003)(4326008)(508600001)(316002)(38070700005)(6916009)(33656002)(9686003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?sQx1ymCTtao/WYlVnCmVF89HGYBz7HGkDHdCA2yGEhy9PJ5bqZKOjgyZ5z?=
 =?iso-8859-1?Q?Vh3Yq/CXWuKRdeBH9gZhoO3wFXgnWKbpBrEWs6SgKIkqXWiwW1KhjdCely?=
 =?iso-8859-1?Q?L5XGGiWyWx5gPGJnYItaOoqtcsb70csYaVB6JLx0Bovg8E0d7f2s5k5poQ?=
 =?iso-8859-1?Q?JLM7tH1kgybbz7hTIKeSsb+QnCSdAxA4FtjWLazw1CW9BBBUp4QpKl/Guh?=
 =?iso-8859-1?Q?G+K22z0ZdBHVe6/PegHLhWkJXZHoZgPH3v6+PTfFQNzhuNO55KJUc6l58m?=
 =?iso-8859-1?Q?+qXZD5qoLxHdoalaPJTKmZp0ws1uZ897tFWQIQ5Xv7H8qdzSMkLKXogarW?=
 =?iso-8859-1?Q?tT7nWBkgxh6LCIeMN2/p0HYFLrtS3/z1VNeEN/LJIzCgL8ynb55yR6ySbW?=
 =?iso-8859-1?Q?8onhrLTZrR4YRfZpzpuSCkWcYKQ4i+yZAr8tRu0bRyLTedvC3VOpXdcRJs?=
 =?iso-8859-1?Q?aWiM8S+OXiAFrxdV5D2KpskrrMsITX5C/yF/Fd1Ap7AUC+SVEWZVCk4BX5?=
 =?iso-8859-1?Q?VplJewMq3cSvJcEIPdD4VfJv6oZCCXZiWbLLeA7ZMcyd0F9v4rJCDrDJtC?=
 =?iso-8859-1?Q?F6yaW1M2zqRUZWZo2jnyAJC7vAGrpI759QmQLhckm4bPZGuU6qsx5PngBp?=
 =?iso-8859-1?Q?7ndtYH9vooL2DYzuYg9IBrpe+ZaWGaHx/1bfHwb2LCaIUldhH0iTZKWcZ7?=
 =?iso-8859-1?Q?SuvtvxgKq+De8p4id7WFjNy16xHEqlqThnnrwyv72Fc5YRvKi2yL3YZDYX?=
 =?iso-8859-1?Q?fraQvn9u+hc1yoztVjwPa/2646XxMMNluZ6cn1iKvFSwnov3vjd/UTWENf?=
 =?iso-8859-1?Q?ry6hDFs/yquDcb2brwzlDzTFmCsdlljcgiVBLJNDtGFU4d6BqJMfZUsb7g?=
 =?iso-8859-1?Q?rjAqn+1v4v+6icI6Etklb/0dVMvWfpuK0AyblvMWRQznAAapaGfuQtue57?=
 =?iso-8859-1?Q?Hdp6BtxoXlMP0Qrm2U8eB/9pEKFPtx71eB9vx2VY/enFhzhdJElXoOHWnu?=
 =?iso-8859-1?Q?6fjML4pjSJTqRqlp8EpFkOagK5q2UKvuYGBP6JfQoBzhJZ+wggRB5h9vAN?=
 =?iso-8859-1?Q?aN6TGpU0ygLRLu26zmwuO4vIbNYMNCQWmXNSZxyrSfpwTKsDAxuot5ZVT0?=
 =?iso-8859-1?Q?HYY4EWS3cTv5O9L3E6t35PBMrodEoaZHPHXVM0O4kdP6f5IOq25W4Yvouh?=
 =?iso-8859-1?Q?iXgqkMqxRjUbVPlYzuj8TPF+yhcVrB/SwT7UTpzWH1+CE2YnmtCqfSGwi7?=
 =?iso-8859-1?Q?Pd4/nNRnBJ0468QDevddroHRrxsDyUy23lPoEf8fmxge5A7sCxJ6Q0gm2K?=
 =?iso-8859-1?Q?S5KOaRGm6xRjib37YZ/20jwIjNvLdtN/Kh1zHQeDolIXh7E6rk8jOXx4m8?=
 =?iso-8859-1?Q?EkvQnY1z2DLSvxQ4l5JSq/CUcPucaHEhn2uLe5OmoogvzVEYWBios=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR13MB3604.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a1170cc-2e76-4e1a-894b-08d97c7467e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 20:22:45.0114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oqmco9agrhGHCAbp0L0r2jT40OtcXrcJCx5jQlh8amdbN0QrRUg1u6+2BTOyWQMe1Fagda5oUb3c1qgKzjKWPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5012
X-Proofpoint-GUID: bE87l1DppHZnCDaO_6PojVU1VJXXywS2
X-Proofpoint-ORIG-GUID: bE87l1DppHZnCDaO_6PojVU1VJXXywS2
X-Sony-Outbound-GUID: bE87l1DppHZnCDaO_6PojVU1VJXXywS2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109200115
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In 5.10 stable kernels since 5.10.65 certain mlx5 cards are no longer usabl=
e (relevant dmesg logs and lspci output are pasted below).=0A=
=0A=
Bisecting the problem tracks the problem down to this commit:=0A=
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-5.10.y&id=3Dfe6322774ca28669868a7e231e173e09f7422118=0A=
=0A=
Here is how lscpi -nn identifies the cards:=0A=
41:00.0 Ethernet controller [0200]: Mellanox Technologies MT27800 Family [C=
onnectX-5] [15b3:1017]=0A=
41:00.1 Ethernet controller [0200]: Mellanox Technologies MT27800 Family [C=
onnectX-5] [15b3:1017]=0A=
=0A=
Here are the relevant dmesg logs:=0A=
[   13.409473] mlx5_core 0000:41:00.0: firmware version: 16.31.1014=0A=
[   13.415944] mlx5_core 0000:41:00.0: 126.016 Gb/s available PCIe bandwidt=
h (8.0 GT/s PCIe x16 link)=0A=
[   13.707425] mlx5_core 0000:41:00.0: Rate limit: 127 rates are supported,=
 range: 0Mbps to 24414Mbps=0A=
[   13.718221] mlx5_core 0000:41:00.0: E-Switch: Total vports 2, per vport:=
 max uc(128) max mc(2048)=0A=
[   13.740607] mlx5_core 0000:41:00.0: Port module event: module 0, Cable p=
lugged=0A=
[   13.759857] mlx5_core 0000:41:00.0: mlx5_pcie_event:294:(pid 586): PCIe =
slot advertised sufficient power (75W).=0A=
[   17.986973] mlx5_core 0000:41:00.0: E-Switch: cleanup=0A=
[   18.686204] mlx5_core 0000:41:00.0: init_one:1371:(pid 803): mlx5_load_o=
ne failed with error code -22=0A=
[   18.701352] mlx5_core: probe of 0000:41:00.0 failed with error -22=0A=
[   18.727364] mlx5_core 0000:41:00.1: firmware version: 16.31.1014=0A=
[   18.743853] mlx5_core 0000:41:00.1: 126.016 Gb/s available PCIe bandwidt=
h (8.0 GT/s PCIe x16 link)=0A=
[   19.015349] mlx5_core 0000:41:00.1: Rate limit: 127 rates are supported,=
 range: 0Mbps to 24414Mbps=0A=
[   19.025157] mlx5_core 0000:41:00.1: E-Switch: Total vports 2, per vport:=
 max uc(128) max mc(2048)=0A=
[   19.053569] mlx5_core 0000:41:00.1: Port module event: module 1, Cable u=
nplugged=0A=
[   19.062093] mlx5_core 0000:41:00.1: mlx5_pcie_event:294:(pid 591): PCIe =
slot advertised sufficient power (75W).=0A=
[   22.826932] mlx5_core 0000:41:00.1: E-Switch: cleanup=0A=
[   23.544747] mlx5_core 0000:41:00.1: init_one:1371:(pid 803): mlx5_load_o=
ne failed with error code -22=0A=
[   23.555071] mlx5_core: probe of 0000:41:00.1 failed with error -22=0A=
=0A=
Please let me know if I can provide any further information.=
