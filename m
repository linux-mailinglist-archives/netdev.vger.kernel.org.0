Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FEE6D26F4
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 19:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjCaRsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 13:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbjCaRsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 13:48:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE5772B3;
        Fri, 31 Mar 2023 10:48:43 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32VHNvp1017369;
        Fri, 31 Mar 2023 17:48:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jTmeLqz6vUTDQkOUi/ZxZRnQ5g7XiDACVFImJ7UUhDk=;
 b=xOwtt7n1POUUmPk9exo9+YTmFF2Ci2fNI6LlwYKdnpv+I11MgaMsVGoSdqlHyt2GFOeA
 2lHRUqYvekbYwSZo8D1LV8oXFGP5vQYeTlHDIw7PQha+nZVFYIwN8rUhJUcdgeoTNxCC
 k8mExj9i+LxGzTjXGaQhB0jq0Efj21Q1ml9Fx6bURf+FpGiGhw2BYYsCpxf5lWuDqwav
 h3tMIwe3lKdkuPv1JKu0FOOak0yiVv5BvnhffW9UYUXJhlJrP/twYpeEWPh8ihDgh9uL
 sY0Jgx2S/3846242S8alwoRgVWGhS1yHiu34YQV37Vng3SwwAh4sQOr/XKGoHiSCwmIQ og== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmpb4xu64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 17:48:23 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32VFvef5024105;
        Fri, 31 Mar 2023 17:48:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdhy9v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 17:48:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VLRtC2OT4a9WAFnVV8L61o2lCbs/n4TbDdtkIU7cglP/xXmTmisngXsItjTFNrT5p2Rkxgw2UjHaVj4OSsJ/mF0ZszOWxFkR7j7RdYNLeHpqDYnPjOnex0jlsRUKB4/D/x3uBECsqKA/K/EHi+w4rarnIieGGEA7uWE9Wbw9dYQ+TXuqvsBBqth6GweL/5Qk2kOc7V0dai2LsxOUlc4GMpcLalY6ojg6tLyj3lbNDOywaV7QYbucxC8WHaYxwfrfszEMFkVNoD8oiqPDfPhAVBZaLxMYGlUWkoW4U4vYIdCmHQdD6CblIf/SW7c+/WhxvI0Tqc9txxaSBpk+4Ymfcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTmeLqz6vUTDQkOUi/ZxZRnQ5g7XiDACVFImJ7UUhDk=;
 b=Evr26/3fENX5b4kHjH4Lq9ou+5XafOt+iICp1t1bU4jxM8f+6H0jIHNW+73VwlhUBq7buV9XoF+D8yv98VKpLUAg2Oyr20in6vx22UiDiEzu4g9v6q2Viwoshm3TTxNeDIJ4kLln/pK3CHXRWsSKfKqfV35yfDwPOyrhS0TXa/FETRYagpESQbJ777mZQyDRYXI8Ram08URPEuAPBCWZK0tflUv8P44bTvgfzLNUeJjHRMVaLLGPkKIkiY8qRhrWGw1nKxjAlKQqrdhVxKyMTS9vEswxW1H76xNuZgOJo4ETdtuij2Du87YtYzMRV8NnaZUSk5hB/0rq9uiN1LGCYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jTmeLqz6vUTDQkOUi/ZxZRnQ5g7XiDACVFImJ7UUhDk=;
 b=rU0TdSC9slQCMjFUqftWMQBUnjnvCXpWA38Xrl4c0w8J+QhCbEGiEeoEa45iEDY5jUyOhM36r9IyYTUd6vYo9D4CwrhXtO6jJR6BeE/QdkTxChXLyJZ0V2G3bVvmAseo5FQdsafRzgYzhOFxZ4+tEmOs19zK2lvyLp/ZSQbAVkc=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by IA1PR10MB6148.namprd10.prod.outlook.com (2603:10b6:208:3a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Fri, 31 Mar
 2023 17:48:18 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6254.023; Fri, 31 Mar 2023
 17:48:18 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] netlink: Add multicast group level permissions
Thread-Topic: [PATCH v3 6/7] netlink: Add multicast group level permissions
Thread-Index: AQHZYmvoV1sxO7snm0CxH2QmxW6asK8UckyAgACtcACAAAbWAIAABocA
Date:   Fri, 31 Mar 2023 17:48:18 +0000
Message-ID: <F49500D6-203F-428C-920A-EA43468A4448@oracle.com>
References: <20230329182543.1161480-1-anjali.k.kulkarni@oracle.com>
 <20230329182543.1161480-7-anjali.k.kulkarni@oracle.com>
 <20230330233941.70c98715@kernel.org>
 <830EC978-8B94-42D6-B70F-782724CEC82D@oracle.com>
 <20230331102454.1251a97f@kernel.org>
In-Reply-To: <20230331102454.1251a97f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|IA1PR10MB6148:EE_
x-ms-office365-filtering-correlation-id: fea01819-fa36-4e50-b441-08db32101c63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6fRAe2xk31Nv9YIMOyi82+ypSNNIsRhTYybCRJp+mlJ2lc0tQry+MIRmP8+5Szwq6wBl1SxEO6TVFqTh7gsd+6IhlUMhxzfWxmubNCo9clY3ttOwcXNktVDxZVCWDVIDVRCfU6UBme062fF2QKO9ADf1+/myDeolHNjGOoYFwPvwFRpImLRCpnAW5gbf0S4i2rRbxW55TaPsUrW598Mz5lOUEhfS6bL/RI0hweWIweZpad+LRQNO/5uAMoiXzljAEcpCbn6JsMhhsr/X+gZNSVni4o171he7eyeQ7nGYPRU4rL3Lye4mYV5kBRjRXmGjodiRgAJj4G/bVg64E9zuR0EjNe4er3iIBqByRhOBGGv2eSo/4E76gv/YcCmSfFPkQjucmIHYOeY6gsY1mDLi+wdXr1KeP0FDnJ+2FGeyMgciuZf8sK5uKzfRmKPW0TVemUV0ExodoKeVi7T9XKdxNfumzdTTdOS2jv7LR5Q7usTazEN/5VhZD8ClATamXwkTzRhGTCM92pmZaYmIKMNCeCBO+LrE12qLM9HrcB8b034KuoAhmZHMc+2DZ8WDcMGsdB7uoeHGH5Ywnc563fH5MfnKhgOJrI/IKjmzQSDu6w0ng3uj4NGJEQZ6hqxSqX4+e9uQWFpXf+ltVwyNSTrd1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39860400002)(376002)(136003)(366004)(451199021)(6512007)(66556008)(6916009)(41300700001)(316002)(71200400001)(38100700002)(33656002)(4326008)(186003)(122000001)(8676002)(6506007)(478600001)(2906002)(91956017)(66446008)(2616005)(5660300002)(8936002)(54906003)(53546011)(76116006)(66946007)(86362001)(38070700005)(6486002)(66476007)(36756003)(83380400001)(7416002)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tk9rUmhNbEo5NEZwUmYwNGliL2plOEU2TVlJSGpZN295VGd2ZnIrai9KbFJx?=
 =?utf-8?B?eDlRdzJwYm5nMHE4K1YyVEdDaEVabDVuZVRuTmg1TDN2L1Vqa1k0azFScjl4?=
 =?utf-8?B?RU90c01MZSsyN1RsWFJPOXlYMFhuYUZPcklGSVZCZTlZejhsS09mMjExV3hE?=
 =?utf-8?B?THZCbi8vK2NmUEJrT0p2ZVVTWDN1ejEvVTFHbkZPNUsxeGVFcVk4VEZKVDUr?=
 =?utf-8?B?NU1pK2ZrdmMveEsydHByd0YraU12bTVua3RlV2ovZHovU0JrdGVHY2F5ZlB0?=
 =?utf-8?B?QzROT2ZxVElPSUZwaFRQSlhyVHRkcjI4QVpFRU5KS3dPSmtpb1dUL2lGSGpW?=
 =?utf-8?B?c1RpSjB0Vi9mcCttU3Mwc2lpYjU2NzhrYWh3UDcxQ1dON1c1bnQ0Mk1iRk00?=
 =?utf-8?B?L0s3RUFxem50QmlKT1ExTDJ5K1FTMGo1Q2NOYkwzS2k4Z2w4VVErY0lDNGg0?=
 =?utf-8?B?cFNXKy8xanFCT2ljb29rcWlCa3pMcFZ0Y2ZnT243Wk16WkxxM3luNmx2N3Ur?=
 =?utf-8?B?eUVNZ0xRU0habHZtUmI0d3kxSFJ1Ulg1akhVV0hOU2tnK09nQ1hoMlVoTDZ0?=
 =?utf-8?B?MjVjbWhUbzBnOXFjOTcvRzhnSXhyVGROTHdBV0JJTC9ESDlwZlA0Zk9ZOW1u?=
 =?utf-8?B?bURCMm9UOURYejUyekNneEVZZkhmQlVFSnJQLzZqdmwyTW9WSUFScEY1cnVn?=
 =?utf-8?B?K0R3blVUNjloWlRGU1FDUWFIQzJieW04Y01LaW51VUdWR2ZBdkVZc2NHRmRh?=
 =?utf-8?B?VG1mdmpqNWdqQ3lkeWVWV2YyMDI1SzFsUU5UeFpHU1ZjWnZCVWcrZWt3MEFW?=
 =?utf-8?B?cDVSemlqTFlBcmRKdnhRUWMxMXRKU3VuSjVlVDR2a1VuNUlKcmNZYW4rdHVM?=
 =?utf-8?B?eW4xR0oxc2xJSkRzNHBFNEYrV01XUFhMaHJIYUtqa3VTZVlobDJhV2RXMzI3?=
 =?utf-8?B?RDFrZlNJZFNnK05JNzhTR2FTTm53elhWMzFoWGZIWEEzQ3h4MmhwSDhYMFhQ?=
 =?utf-8?B?OUFDVXRWRG1ESWh5RnF4Z3BnREVFTS9jLy82WmxxOWhYOHZtaFQzOTlnWGFn?=
 =?utf-8?B?bU9lQ1h3U1pqSENtZ1pKNlNRbW5EdTAzT0JSTmQyRXhuT2Eybk00OGNVbzQw?=
 =?utf-8?B?WWgzNzJnYTM4YXFOZ3N3WWxnaEFFRmNLY3B5OWp0SThTMzN1UzFpQUNtUWV2?=
 =?utf-8?B?ZEVhZ0hTdmduc3Z5Q0xBR0ltelgvWS92dWdYMW4zOEovalRuNlp2TFltdHIw?=
 =?utf-8?B?NW5SUEZaSEV1QXJSSURhK2hnejBNVm9PdXBPR3l2L0RIRXlwWTg3dXRXQ2lk?=
 =?utf-8?B?R1NkN1JBa2ppc1Y2VHFwenoxL1UyeWtOME5KdXFmU01DR3VoZ3pWSVk1T2o5?=
 =?utf-8?B?L1dNcHdkVVIraTB5VUJVb2didzIxTTVROUs5SktuNU90dGtwSnVmd2RoZS9h?=
 =?utf-8?B?cEVuOWNvcVJWUFQvUUpJbHJ4WkRyRGNzaFZmTkpJYk01dTRzaVlFS2tXR2R5?=
 =?utf-8?B?K3k1QW4wUDU5TU9Ndm9JMEJxT09IbjdiWHlpSzhENkhPY0t6T0hHNWNWY3Iy?=
 =?utf-8?B?eUFDbVlrZCtKQmxNMzkzVVBNaVpFRE5lbkVjMFdMWFMzdE1QZk53UjlRd2Zq?=
 =?utf-8?B?dnU3d2ZKQUFjRUxTTEdETkVrU2xwRmFodWhxTks1TDFpb29GQWNONGxHa2hz?=
 =?utf-8?B?M290UXNEM1RUdzJtTisxMGF4Q3dKMHRrK2VnNkNmRW1MQ1VIcFcyWXBqTG1R?=
 =?utf-8?B?U2lxTFN3M211bXY1bThGZGRDRFdFT0U1Z25taEhCdHU2K2NWbDRaaGlvbGN3?=
 =?utf-8?B?cVFQcVZuV2grbEFDY2dXbHdzSENJbVRaWE5TSVFyOXh0cDVsdG45RllxK1E2?=
 =?utf-8?B?VzBoS1VPZVZQQS9jUnRYbjJzMVUrQnlLTFZEd21HaDRGUlMyOHVhWnQwN2Rs?=
 =?utf-8?B?NUNlZFlrSDJ6ZUtUSmpFdStGZDJ5TDdpdG00SCtmNnhiY3dnTmlxOGFsZVU4?=
 =?utf-8?B?UHphMTA2WE14SnBoelVWcHpWQWVKZGN3Szlsdno1QktFdE5xMk1ITURPMDN1?=
 =?utf-8?B?UExlOHlreGhoVWZsa2I2RitBTHY2dFlmQ2w0NEJnK2kvWHM4Z0t0ZHRhZEIy?=
 =?utf-8?B?UnhVeERvaFZ5bmNlRHlEcU5BM3p4N3hHK3U5NVdBRktKY0NQdTJYZ3c4Q1pS?=
 =?utf-8?Q?aN0VYSyGx+8ZZOK07GACWGEm3nbcCBwv0uUfL3hIh6QT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <916FB5E0BFD90646B0B822E2DA9D7772@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?clRINHUxQm5uNzF6eUxmb2lpaWdLU3NHQXRFRmVna0cremN6N204TFFGWkdD?=
 =?utf-8?B?amFGdlRGNDRMK2RXSmNjQ2JFVlZab21jREVhRGR5RUdZemtpKzVOaG1qY1Bn?=
 =?utf-8?B?UFI5TWVzZDNheTZOMzZ2NjNNQlY1T0x6OWIwN0FBcVI3a0kwZ1ZIVjd1U1JW?=
 =?utf-8?B?ckt4a0t2ei9iSVg2aFpLbXdOaVJMSXE5c2tSLzJFWU1ZRE1zMFVESnY4cnV0?=
 =?utf-8?B?aU9ZTWlyNDFCWjhzblRPYkliemZWaHZxdXpVK1hUMjBMSzNhc05QU1hWQ2Q5?=
 =?utf-8?B?dUlUeC9rUHBLYVNpeUk2RUZXZ3hCWVZIQUE4N1ViZFdwMUZHTkJOM1BndzU5?=
 =?utf-8?B?M3pUMkFjMUNpZUNIajJkUWZWemhuTFhKZnh6RVFndDlMd3liQ2FXZHpFNm1m?=
 =?utf-8?B?ZUpKeHBPQ1MyenQ3c3kwOVJmdUI1Z3poTXJ6RGZPZkZ4enBDZ0tzbndzUVNK?=
 =?utf-8?B?aTE1d3RkTzhKekQyRDJPRXl6dFlFVFRXdmloS3IySFZlQmVxUTI4czl0ZlNt?=
 =?utf-8?B?OUE0Rzd0Q3dsVjZNTVNEZXdCeVphVnJvcEY5V1hCNkRteklLTnZNK0xIbTRY?=
 =?utf-8?B?WjQzeWZBUWRscmFWMlhIWEYzeXhuaDUzUCt2QUZqNXdLb1ExSFgxOXlWTDBM?=
 =?utf-8?B?cXBmYWRIWXl6ZW1lcmRXaHBoQmRaeGxZYUhyYzBBYko1VmFUVTg2UDhoa0Nl?=
 =?utf-8?B?ajhXMllmbHFja2VWbzRDQUkwMCtTTkhVVWdpekhucHowVm1aV1BrdE9Ed2Nx?=
 =?utf-8?B?Z2RzNDNmUHpEaHBnVXk5b2UyNk50bEJvbmlBdHB0dUhXUnFlVkNzV2lZeWRv?=
 =?utf-8?B?TEE1dlZ2bFNZdmVzVnErbllvQytna24yQmE2RGg0TUhRS3B6VTJWa2poSlVC?=
 =?utf-8?B?Y2VtbnF2WVRWRmk2eFpsZW9sbGlHbnVRQVg5YzhWMGZ2ZlB2SHVJSWJqMWRs?=
 =?utf-8?B?VVZBcHdPTDdzbk9JTnljazZvbzE0VFAwZXY1eGk1Z21PUU5mdUpISkliKzBH?=
 =?utf-8?B?YWs2VS9kcWhJWllLSjdhYVo3WVdQSmpEYW5NZWJ5bzZ5UXZ6R3RCTGNUamJB?=
 =?utf-8?B?YUIrNGYwZk1oTWNzcXA4MVg3OWUzYmdBL1cyRzdPd214RFc3UTNodDJwMmkw?=
 =?utf-8?B?T2VUQjV3em55c1pLOVMrTS9wTGUySisxZ3ozb2JZNk1sTFQ0S0p5V3ZxWXUy?=
 =?utf-8?B?dXVvQ2FEV2RMdXFOZXgxbHRtN09DblBETStLRkpLci9FUmZxL0xJcFR3anBS?=
 =?utf-8?B?N1JlbU1vOGlsWWNjU2VjZTJIM3d2ZGN6YmRIWkdpNmMwZm16RUFrYWsvVC91?=
 =?utf-8?B?Y2l1SFEyZnZ3OWJWQlpTRk15TVdMcnJnN0IvVlVlMEprZmZDUk95R0ZQaHNO?=
 =?utf-8?B?VW85a21JcnhreXFaNHo3aEM4YlV6R0xwSHM4a1RFQmZlUGh5UzZISFpQK3Uz?=
 =?utf-8?B?MXl2SHdZWE9RN0xCQXY1UHh0cWhFS3c4MFR1VzZBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea01819-fa36-4e50-b441-08db32101c63
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 17:48:18.0193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3WMCM3GUwy6UXue2En6pbW68IjiObiynjmNyhGJtZXjyFl60OKove4Gf55NqoDNQ0CiYfJkLh8Csm0NmT2AId/K3JYKc1jGqBfeF9nrxEOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303310143
X-Proofpoint-GUID: dUz4_cAe7wvUr8HipuIz00ndvhREM9w3
X-Proofpoint-ORIG-GUID: dUz4_cAe7wvUr8HipuIz00ndvhREM9w3
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWFyIDMxLCAyMDIzLCBhdCAxMDoyNCBBTSwgSmFrdWIgS2ljaW5za2kgPGt1YmFA
a2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBGcmksIDMxIE1hciAyMDIzIDE3OjAwOjI3ICsw
MDAwIEFuamFsaSBLdWxrYXJuaSB3cm90ZToNCj4+PiBJcyB0aGVyZSBhIHJlYXNvbiB0aGlzIGlz
IGJldHRlciB0aGFuIGltcGxlbWVudGluZyAuYmluZA0KPj4+IGluIHRoZSBjb25uZWN0b3IgZmFt
aWx5IGFuZCBmaWx0ZXJpbmcgdGhlcmU/ICANCj4+IA0KPj4gQXJlIHlvdSBzdWdnZXN0aW5nIGFk
ZGluZyBzb21ldGhpbmcgbGlrZSBhIG5ldyBzdHJ1Y3QgcHJvdG9fb3BzIGZvcg0KPj4gdGhlIGNv
bm5lY3RvciBmYW1pbHk/IEkgaGF2ZSBub3QgbG9va2VkIGludG8gdGhhdCwgdGhvdWdoIHRoYXQg
d291bGQNCj4+IHNlZW0gbGlrZSBhIGxvdCBvZiB3b3JrLCBhbmQgYWxzbyBJIGhhdmUgbm90IHNl
ZW4gYW55IGluZnJhIHN0cnVjdHVyZQ0KPj4gdG8gY2FsbCBpbnRvIHByb3RvY29sIHNwZWNpZmlj
IGJpbmQgZnJvbSBuZXRsaW5rIGJpbmQ/DQo+IA0KPiBXaGVyZSB5b3UncmUgYWRkaW5nIGEgcmVs
ZWFzZSBjYWxsYmFjayBpbiBwYXRjaCAyIC0gdGhlcmUncyBhIGJpbmQNCj4gY2FsbGJhY2sgYWxy
ZWFkeSB0aHJlZSBsaW5lcyBhYm92ZS4gV2hhdCBhbSBJIG1pc3Npbmc/DQpBaCB5ZXMsIHRoYXQg
b25lIGlzIGFjdHVhbGx5IG1lYW50IHRvIGJlIHVzZWQgZm9yIGFkZGluZyhiaW5kKSBhbmQgZGVs
ZXRpbmcodW5iaW5kKSBtdWx0aWNhc3QgZ3JvdXAgbWVtYmVyc2hpcHMuIFNvIGl0IGlzIGFsc28g
Y2FsbGVkIGZyb20gc2V0c29ja29wdCgpIC0gc28gSSB0aGluayBqdXN0IGNoZWNraW5nIGZvciBy
b290IGFjY2VzcyBwZXJtaXNzaW9uIGNoYW5nZXMgdGhlIHNlbWFudGljcyBvZiB3aGF0IGl0IGlz
IG1lYW50IHRvIGJlIHVzZWQgZm9yPyBCZXNpZGVzIHdlIHdvdWxkIG5lZWQgdG8gY2hhbmdlIHNv
bWUgb2YgdGhhdCBvcmRlcmluZyB0aGVyZSAoY2hlY2sgZm9yIHBlcm1pc3Npb25zICYgbmV0bGlu
a19iaW5kIGNhbGwpIGFuZCBjaGFuZ2luZyBpdCBmb3IgYWxsIHVzZXJzIG9mIG5ldGxpbmsgbWln
aHQgbm90IGJlIGEgZ29vZCBpZGVh4oCmPw0KDQpBbmphbGkNCg0K
