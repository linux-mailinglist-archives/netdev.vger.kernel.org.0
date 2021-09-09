Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5965F40567A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359761AbhIINT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:19:58 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44186 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355015AbhIINL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 09:11:29 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 189AewCL021525;
        Thu, 9 Sep 2021 13:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Ws6Korzyb1DEuwkvW1nJ8yBtfW4YCOjrSQbq5zMCaaE=;
 b=nSSdjoq7AmQSzxcX/jXlqM3UMNDfrjWApTCRUSdzKyo0OlcZ0vJDvIORBD06TEjz7iGR
 lXwDZTPwnFUka4gmln04MGf02gxlhncq/lY1IMVwPT4Qz6O8YVhYGsTz9EXSDTF7INTA
 b0kqFdKuga6MvTr4b191I7mHG3EiYeqtScBBItGF3gObfBbYb28SqsTwCU09crYD+IrD
 kBUh0wl4mgZAmdoChTxvE+fFuMGwWHBO/7H+gcP7+QEilvflHhjr7YMQpoX5hhAEXBWf
 VksQSZfhcVg8wHLmoGTwIvNh40SUHw6IhCcazWWE6S4ScYqfOW8sDheAMc93yqHEexGW Lw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Ws6Korzyb1DEuwkvW1nJ8yBtfW4YCOjrSQbq5zMCaaE=;
 b=NueaJHyCTtkMU1MsN4OitkNsdNi8CmSYXvw2cP5MbgE7sn2PzwkguYCyuRSwMAlKZWZi
 yN6TDHCjiHJS1f7G1ASN3Vog76MyXZBtihYK2bC166whDKxMXLDq7f/A7j5E3LWDBPeX
 zgDbrH6dRjs5plu6KAO9E01WCSiyWnstLrcJ27Cg46lze64ghjeqEJECtU80UYejaCxb
 yWeH/LtN9Nu1Fq7hHhJi8aSurLljkQJj1vziBtw4DObpAAltMH2j6f/JU1r4uvGE+ghb
 ZerHeMOV52XpimZx36+XduZ2tdXrsT0WbWjj7RDj9+yLFD/TnDRuV62ulIMlHpNxDX9/ /A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aydw411kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 13:10:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 189D0rd7011006;
        Thu, 9 Sep 2021 13:10:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3030.oracle.com with ESMTP id 3axcq2xxtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Sep 2021 13:10:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPyiSl85sNe/6QJZoNbS98oeEiwJq/FzLMlsJJi1tD/iLCMuG+ITXyFHbMjHu0WZBVrgZ3tptkM7b+z4YZGVXj5vPVJ37/JaP3TcQ/PdXjU+MDhQQ8I2p4YI2V4+LZBVxBdA0n51q+52gfehAU+HOoGyx01rdDHEy8MOOWSf0+WCc5VXTdGX8KOa4R3Q2ThCaqgzBCdyRt6UIBO2DidRJZlK/46cE2fC2SXh13398Zav4FFwsHoU35cYs1vFVE9zhK4aLfeeS6RPsU+aHf1hDzFlEKB5FmcNAvI3ircJJa77StFrkDsT7eVspCwZGYZBHB6V89Z0gfOQ++F62qU8Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Ws6Korzyb1DEuwkvW1nJ8yBtfW4YCOjrSQbq5zMCaaE=;
 b=HtAcvwvZOsU084JrTfBhnKwUPPIitvAFsV3+jwg65rzDxF+0ohEQygNNCGZ3L3jfFBTHiqKWWbLwa7OVXv3PGOlBbW9FF2opejQgxW5XgkvBX/5Qg3uK6sBSJOX4NvmEC+Kvt1DndmWFyKin4LnVpfzaO1tNEV/HfxTzUEicxf8XZaRGG7YpbTSCztuM6pAyX84SL+Th1mPTFLBo4KuDBtCdX18w/IcT9l6UIwfcWRP52PvLf6G0x7UL07k6sA/2f0ovJs0Zw2NjGZkyC9kS+07iFyy1fZhjqRgE2XsFJnWKJbTvNmpfcufY0i6saYbSGsrwkrwp7Uk4gmjYqNTWoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ws6Korzyb1DEuwkvW1nJ8yBtfW4YCOjrSQbq5zMCaaE=;
 b=kf2teBrlGz+KzqX+n3T6hf0wdSEeTuh/qUkczG7i9XLXOs3Dcu1KVnIpUZEnBH09KdLPnELPcpGNi/VOWXhVy+3DoflKNDBkquoPMDA7WSgbCqdwfEqH6TDu/YanmA5uaKltxOPwLhDgqvADYtWh969JXECr4tLU+hcJScTJ9TM=
Received: from DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17)
 by DS7PR10MB4941.namprd10.prod.outlook.com (2603:10b6:5:38f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 13:10:05 +0000
Received: from DS7PR10MB4863.namprd10.prod.outlook.com
 ([fe80::847d:80e0:a298:6489]) by DS7PR10MB4863.namprd10.prod.outlook.com
 ([fe80::847d:80e0:a298:6489%7]) with mapi id 15.20.4500.017; Thu, 9 Sep 2021
 13:10:05 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Linux-Net <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guillaume Nault <gnault@redhat.com>
Subject: Please add 2dce224f469f ("netns: protect netns ID lookups with RCU")
 to LTS
Thread-Topic: Please add 2dce224f469f ("netns: protect netns ID lookups with
 RCU") to LTS
Thread-Index: AQHXpXwB9uiZyfI9lkyCqWjXsXAVUw==
Date:   Thu, 9 Sep 2021 13:10:05 +0000
Message-ID: <7F058034-8A2B-4C19-A39E-12B0DB117328@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4efe7b2b-55b8-4237-1dd4-08d973932431
x-ms-traffictypediagnostic: DS7PR10MB4941:
x-microsoft-antispam-prvs: <DS7PR10MB49419A34215A2FF5852FDD56FDD59@DS7PR10MB4941.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:451;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UBSYZWkk07B+IwSLkFyfE0Q5nzrOuYdAFTVAeQx1oC65chdfGWDTg+EU5j/CC9y/NTbBxa16XoUs3042f2GMjhLWA9POIOnHcHhlkKIDHvEcHvEey6hxTL/1q/GsIdqMrvXQ3/G4A43hZgAoexipqUqCTkJ6PWQSyeWsibhr+xrNsmXJsi1j7E70TMzWqNcvW2o+pHLu8MEPNsrCqoM/jg5Z3Zw9XLxQCZl9VLlvVcOpC+mFN0gAY/He3Dhi9+D0gVpjbCTf0QiGDhGdOdEO/LDM8GgQypgds4OBBJcLlXp6kCFOPhiNuk9hNm2XS4x1CYt+TAWIYpTsBCFZqtqJ31Wfzm/MQOyli8QF+y9PFvkxZ1N9C3ehZRzs9EuA/G7g2k0jJblNs6oRyWk5z5flW3vLytnXQAGVqkJzPHBEwwUhNWFdDoeRUf9IG9KV2yIz5RROwrF5rDROxJchnU+MWf+e/fta2424q+rmsLPTpSnyx1IqOEnlC7qLxoU6dUexEIAf/BXn1mzU8QCZq9zwuXEGW77EJfOoW6YnAbxmO5fjKhcxdW5V6OpzXWgJynvG1/F+s27KT8BEIYd/QSZ+zk9jTyzS7yeUxonPkmUNeWAz5x2d2Rhm8zV4kiIrR7bDFCoqJjP4MKl43LQRf5oQp5kLe8WLl+WWYFFOsBp+ADzd1lHCR/CVgpDz7T2XWnuWDzAsXvrvZ+EFTcRZGIbgrhXUfR+UlGhMFKdxVUKXaq4LfDf2ZKwnEQBY4e72pyTn3hFr3Oxhv+cn4Tda6D+ZoQZLR9Pf4Vq/F/G7bB0acDFcw4Hs7Aed35klZIKwoUYu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4863.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(346002)(396003)(316002)(2616005)(91956017)(8676002)(478600001)(76116006)(44832011)(26005)(38070700005)(86362001)(2906002)(66556008)(66476007)(4326008)(122000001)(38100700002)(7416002)(33656002)(6506007)(8936002)(66574015)(83380400001)(6486002)(110136005)(54906003)(6512007)(71200400001)(186003)(66446008)(64756008)(66946007)(5660300002)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1ZXZnRZWldBdUJGa1p3ckNTdzJXVVZ3WC9Fa0FIOVJSV1JjVWFYTkxlbURs?=
 =?utf-8?B?elQrSldtR3lHV0kyWWRvM3E4VlZ5SVF1ZXp1U2t1anV5aFdJQmxCZUNBdU1W?=
 =?utf-8?B?RWthSUNsUUxob29CR0VaSGZhU3R2Rk9DR0UyL2JyYmJSYVdNR0RFZWZUMzFy?=
 =?utf-8?B?K1piRjVGK3VBWlA0OG9ZTHZKc1dld1lEMnF5bHlnZThvalpJSWFLYk1QNlNp?=
 =?utf-8?B?ZFNpSFhIV3V4NnFnZGpuUmtKYVMyLzAzYjBydHJRWkhjNzlsY3h6V283NElr?=
 =?utf-8?B?V2M4MXI2Uld2ZUpqdlk4eER5ZnBPUnZMQ3FGSFQ0Sm01eWdzVnd6bCtvYlY5?=
 =?utf-8?B?Z3hjNUp3TXBMYy9HTmZhTUZkamQvN3ZzSXJ2cjBEcFQ0cWl6RDFjRStpRXNm?=
 =?utf-8?B?ejdacjh6cWIyNEpSM1hUdm1aRHBIRmYwWmVNeXoxL05ES0FKWTFEK3RuNlZl?=
 =?utf-8?B?VUd0NWt2dTVOalp5UTlIUThPMXpOeEpQdVJsVTBDcTVUeGN1RGZyYllRY2V1?=
 =?utf-8?B?V1JrTmZocFZZWmdiMlRuOWlUdy9Rb0Vya2JLSndRak5pb3ZlUHN3Y2NrcWVB?=
 =?utf-8?B?UVNueGZLK1FrWHFMWUYyY3VsdVc3ZnNWK0M4cGg0eVB2SEZmUmpMb1lhOTE0?=
 =?utf-8?B?S2t0K0d6VS9SdWt1UWhWc3J0R2NqUkUzRXdlemFZbFJud0hrUU1PSStuZENr?=
 =?utf-8?B?MDZnVi8vTFQxOHlhVDJWMEs1RXRtQngyTGYxc0o4aDcxVGFUZHRPZ2pYemRk?=
 =?utf-8?B?VnRicjhEVzlVcXRzZlVRaGlxVmphbFkvVCtNVDBtZHZvZHBkbXBPK2Z1MFl6?=
 =?utf-8?B?OG5vVU1oVjhkWmVRZTRnTEhJR1Yzek5ia25WM0JXQWV2bmlxOXJPd2pXL2NX?=
 =?utf-8?B?ck00WmFFeGM5UTZENWNRZEdrWC9UYXdNdlRNako2aG1zcEsyYTFMRFBGY2dB?=
 =?utf-8?B?MzA1NzQ3TkFiS1NtYlBZT3dzV295eTMwZXJqQTBrL0FHc3RvL28vMUhyeDhN?=
 =?utf-8?B?cit1RlZ5RUZZRFAxeWVVYU1RZXo2YW1QTi8xZkxna0VhaW0xNHcwYS9DRXBE?=
 =?utf-8?B?WDlRUnE4SlRwelNxOE5iVXUrUzBkcCtrRUF5RnJRSTRnOUFqc1JMZlI0cVhW?=
 =?utf-8?B?cytuL0llL1JFT3FBeWgxcFBnK0E0MmM1d0VDTHU3YTFlM0Fmb3U5TEZ5SVdL?=
 =?utf-8?B?T0tqNGJJaEN1eXNmeTJjRGxvZzhyUUNSZTlJalJsbFZDLzBMdTBjVmFHME5h?=
 =?utf-8?B?ZldvajhEdzIvVFh1aGU0bGVqVnNjTXM1VzRPMngrRWFESUpYcGwxNGwreXNB?=
 =?utf-8?B?K0hYV1ovdE1YcGlPZFB6UE9sYk5GVktENWM4Z1RTQ1N4TVRIWEdFTXVPTFVI?=
 =?utf-8?B?WHFEOXhUaERVRkxwRDQ4b2RMN0NtWEFGZmVhejQ0SFh5Yk9oeU5OVW9CR0gv?=
 =?utf-8?B?c081RnVRb0FGdXVrQ2R4L1c0R3YvUVdReVArcDFsc3JuYnhuWUkzbUhtUTJh?=
 =?utf-8?B?dWt5UHpvdmorWlJHc2dRR256ejFkTmR2eG5VWEQyR2ljbWZLTlpmVGJsb2Q5?=
 =?utf-8?B?b0hybUR3NWUvWmtjV2xSSGJhV2FZSTF5QnNCVms4bkN2Y2pjcW9hOFQ1ZjdT?=
 =?utf-8?B?K2JKTG9vY2c1VW4wdjNjWFdKc3RWZU1oTnEybk9TcGdFQTNLVmxYTXhYSXdC?=
 =?utf-8?B?eHQwQ01pd3ZFWlRmOVZpUEt0NTJISmlkM3pEUWZBK3p3N0s5a1RWOTZ2TEhL?=
 =?utf-8?B?NTJRbitIMnVtRWovbmNvNU50UzdwUHlJdmtlZ2QzY1hRL1hCQ3NkZGR6QS84?=
 =?utf-8?B?VEkraEtJSSt6eDB3bldMUT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A66EEBE9AE15654491E1D62BD80F9A92@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4863.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4efe7b2b-55b8-4237-1dd4-08d973932431
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 13:10:05.3225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WJF7o3k/bJMAw+72vSpVaJONEnkHreocF1ByPb+VZ78HcVnJAobuL2O4B+lr1LEU1Q3M44lxw04SOotTrDtAeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4941
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10101 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=903
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090080
X-Proofpoint-ORIG-GUID: 5Cc91Co80mRt4Y5ke_JCmmk10ajCGcHm
X-Proofpoint-GUID: 5Cc91Co80mRt4Y5ke_JCmmk10ajCGcHm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR3JlZyAmIFNhc2hhLA0KDQoNCnRsO2RyOiBQbGVhc2UgYWRkIDJkY2UyMjRmNDY5ZiAoIm5l
dG5zOiBwcm90ZWN0IG5ldG5zIElEIGxvb2t1cHMgd2l0aCBSQ1UiKSB0byB0aGUgc3RhYmxlIHJl
bGVhc2VzIGZyb20gdjUuNCBhbmQgb2xkZXIuIEl0IGZpeGVzIGEgc3Bpbl91bmxvY2tfYmgoKSBp
biBwZWVybmV0MmlkKCkgY2FsbGVkIHdpdGggSVJRcyBvZmYuIEkgdGhpbmsgdGhpcyBuZWF0IHNp
ZGUtZWZmZWN0IG9mIGNvbW1pdCAyZGNlMjI0ZjQ2OWYgd2FzIHF1aXRlIHVuLWludGVudGlvbmFs
LCBoZW5jZSBubyBGaXhlczogdGFnIG9yIENDOiBzdGFibGUuDQoNClRoZSBkZXRhaWxzOg0KDQpG
cm9tIGJ1Z3ppbGxhLnJlZGhhdC5jb20vc2hvd19idWcuY2dpP2lkPTEzODQxNzkgKGFuIGFuY2ll
bnQgNC45LjAtMC5yYzAga2VybmVsKToNCg0KIGR1bXBfc3RhY2srMHg4Ni8weGMzDQpfX3dhcm4r
MHhjYi8weGYwDQp3YXJuX3Nsb3dwYXRoX251bGwrMHgxZC8weDIwDQpfX2xvY2FsX2JoX2VuYWJs
ZV9pcCsweDlkLzB4YzANCl9yYXdfc3Bpbl91bmxvY2tfYmgrMHgzNS8weDQwDQpwZWVybmV0Mmlk
KzB4NTQvMHg4MA0KbmV0bGlua19icm9hZGNhc3RfZmlsdGVyZWQrMHgyMjAvMHgzYzANCm5ldGxp
bmtfYnJvYWRjYXN0KzB4MWQvMHgyMA0KYXVkaXRfbG9nKzB4NmEvMHg5MA0Kc2VjdXJpdHlfc2V0
X2Jvb2xzKzB4ZWUvMHgyMDANCltdDQoNCk5vdGUsIHNlY3VyaXR5X3NldF9ib29scygpIGNhbGxz
IHdyaXRlX2xvY2tfaXJxKCkuIHBlZXJuZXQyaWQoKSBjYWxscyBzcGluX3VubG9ja19iaCgpLg0K
DQoNCkZyb20gYW4gaW50ZXJuYWwgKFVFSykgc3RhY2sgdHJhY2UgYmFzZWQgb24gdGhlIHYFNC4x
NC4zNSBrZXJuZWwgKExUUyA0LjE0LjIzMSk6DQoNCnF1ZXVlZF9zcGluX2xvY2tfc2xvd3BhdGgr
MHhiLzB4Zg0KX3Jhd19zcGluX2xvY2tfaXJxc2F2ZSsweDQ2LzB4NDgNCnNlbmRfbWFkKzB4M2Qy
LzB4NTkwIFtpYl9jb3JlXQ0KaWJfc2FfcGF0aF9yZWNfZ2V0KzB4MjIzLzB4NGQwIFtpYl9jb3Jl
XQ0KcGF0aF9yZWNfc3RhcnQrMHhhMy8weDE0MCBbaWJfaXBvaWJdDQppcG9pYl9zdGFydF94bWl0
KzB4MmIwLzB4NmEwIFtpYl9pcG9pYl0NCmRldl9oYXJkX3N0YXJ0X3htaXQrMHhiMi8weDIzNw0K
c2NoX2RpcmVjdF94bWl0KzB4MTE0LzB4MWJmDQpfX2Rldl9xdWV1ZV94bWl0KzB4NTkyLzB4ODE4
DQpkZXZfcXVldWVfeG1pdCsweDEwLzB4MTINCmFycF94bWl0KzB4MzgvMHhhNg0KYXJwX3NlbmRf
ZHN0LnBhcnQuMTYrMHg2MS8weDg0DQphcnBfcHJvY2VzcysweDgyNS8weDg4OQ0KYXJwX3Jjdisw
eDE0MC8weDFjOQ0KX19uZXRpZl9yZWNlaXZlX3NrYl9jb3JlKzB4NDAxLzB4YjM5DQpfX25ldGlm
X3JlY2VpdmVfc2tiKzB4MTgvMHg1OQ0KbmV0aWZfcmVjZWl2ZV9za2JfaW50ZXJuYWwrMHg0NS8w
eDExOQ0KbmFwaV9ncm9fcmVjZWl2ZSsweGQ4LzB4ZjYNCmlwb2liX2liX2hhbmRsZV9yeF93Yysw
eDFjYS8weDUyMCBbaWJfaXBvaWJdDQppcG9pYl9wb2xsKzB4Y2QvMHgxNTAgW2liX2lwb2liXQ0K
bmV0X3J4X2FjdGlvbisweDI4OS8weDNmNA0KX19kb19zb2Z0aXJxKzB4ZTEvMHgyYjUNCmRvX3Nv
ZnRpcnFfb3duX3N0YWNrKzB4MmEvMHgzNQ0KPC9JUlE+DQpkb19zb2Z0aXJxKzB4NGQvMHg2YQ0K
X19sb2NhbF9iaF9lbmFibGVfaXArMHg1Ny8weDU5DQpfcmF3X3NwaW5fdW5sb2NrX2JoKzB4MjMv
MHgyNQ0KcGVlcm5ldDJpZCsweDUxLzB4NzMNCm5ldGxpbmtfYnJvYWRjYXN0X2ZpbHRlcmVkKzB4
MjIzLzB4NDFiDQpuZXRsaW5rX2Jyb2FkY2FzdCsweDFkLzB4MWYNCnJkbWFfbmxfbXVsdGljYXN0
KzB4MjIvMHgzMCBbaWJfY29yZV0NCnNlbmRfbWFkKzB4M2U1LzB4NTkwIFtpYl9jb3JlXQ0KaWJf
c2FfcGF0aF9yZWNfZ2V0KzB4MjIzLzB4NGQwIFtpYl9jb3JlXQ0KcmRtYV9yZXNvbHZlX3JvdXRl
KzB4Mjg3LzB4ODEwIFtyZG1hX2NtXQ0KcmRzX3JkbWFfY21fZXZlbnRfaGFuZGxlcl9jbW4rMHgz
MTEvMHg3ZDAgW3Jkc19yZG1hXQ0KcmRzX3JkbWFfY21fZXZlbnRfaGFuZGxlcl93b3JrZXIrMHgy
Mi8weDMwIFtyZHNfcmRtYV0NCnByb2Nlc3Nfb25lX3dvcmsrMHgxNjkvMHgzYTYNCndvcmtlcl90
aHJlYWQrMHg0ZC8weDNlNQ0Ka3RocmVhZCsweDEwNS8weDEzOA0KcmV0X2Zyb21fZm9yaysweDI0
LzB4NDkNCg0KSGVyZSwgcGF5IGF0dGVudGlvbiB0byBpYl9ubF9tYWtlX3JlcXVlc3QoKSB3aGlj
aCBjYWxscyBzcGluX2xvY2tfaXJxc2F2ZSgpIG9uIGEgZ2xvYmFsIGxvY2sganVzdCBiZWZvcmUg
Y2FsbGluZyByZG1hX25sX211bHRpY2FzdCgpLiBUaGVyZWFmdGVyLCBwZWVybmV0MmlkKCkgZW5h
YmxlcyBTb2Z0SVJRcywgYW5kIGlwb2liIHN0YXJ0cyBhbmQgY2FsbHMgdGhlIHNhbWUgcGF0aCBh
bmQgZW5kIHVwIHRyeWluZyB0byBhY3F1aXJlIHRoZSBzYW1lIGdsb2JhbCBsb2NrIGFnYWluLg0K
DQpJIGhhdmUgdHJpZWQgdG8gcmVwcm8gdGhpcyB3aXRoIG5vIGx1Y2suIEJ1dCwgc3RhY2sgdHJh
Y2VzIHNlbGRvbSBsaWVzIDstKQ0KDQoNClRoeHMsIEjDpWtvbg0KDQoNCg0KDQoNCiA=
