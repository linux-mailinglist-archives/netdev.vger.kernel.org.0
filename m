Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736723EBBBD
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhHMR7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:59:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55430 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231960AbhHMR66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 13:58:58 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DHpN1B016274;
        Fri, 13 Aug 2021 17:58:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qZ1mYYjrrHHoy3Jf3EvXj/lIUvn+1GWKER0kg4fa5Rc=;
 b=rNEo3zYZwtMN9VzTfmrj3iFT8a5G2J+loCpP9N2u3w64S0bDo6DU0BPaV9zdJ+L3YegZ
 5OCx3qlzwJwbPN3uoZwts1uEsfr3LhCo5ynnB9a7pRN/NlJYaBRlFMt7CwdWTv+P4Wac
 dmkH3LC008pSSiqNCwtIZTKElEEDHT98EiFE2hImxHXguLNDOlBuKBwIAOO+rUovjGab
 +VipPeHDd27i7rFf+7zZVH0Ls66+dTxCCaCn1UCYGxqat14SRHKhCAy5DfBMPoz8uRuJ
 erp//WWosMXO8+w5807AMltbvmvgZ6G/IJRJ7zql8QuHzzT9dPMwNeeGGIjdjdCRLT6x xg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=qZ1mYYjrrHHoy3Jf3EvXj/lIUvn+1GWKER0kg4fa5Rc=;
 b=Mb7xbe79mp0dfQ21Hxn1w8hMP+je+N4c3p43qr5olHwitXOI/CKisF67RI4gvPmWeYKC
 wyudVvLZSmPrrZUbs26GWDcJ5VTosyQlaf3BtN0J8WqL+5LgyViRyOuervI42mhA2TrY
 UiXosX2XnYdW5hJ+e11WNbqidez9UbnsEhL3P8MUH4dJhBL2R8mZnEw7si0uhGk/GmbW
 SjOG+tlqvUqUokzGNmTwvXG+l3H1+LzLnw1zsjYk2MHMVKEemczuklA31PknqNrAGt0L
 SC2RfPMa1SKFn/f/mib9a4c4Bkinv+U3xy4Fu9hOjyUDTvsP0IjW9+sEsyG9SPUu6HiB NQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3adq9g8y3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 17:58:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DHoKuZ022840;
        Fri, 13 Aug 2021 17:58:27 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by userp3030.oracle.com with ESMTP id 3abjwb35ft-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 17:58:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsUXFVqksqqVjdS6sMt513cDOqZxZxX/buK+NybtrBMXgHybL4sgmgbT98AGSPdZ4WDSRBBE9m0QfmJ06jUxPCN5OnHzyVCvnzqC/qOWQjQZcHNHm691JVfxUJkm6zpLorru+NlbMoX7TVkvxCR6pQzY34yX8X4KWY2nh5GY5DRzr2RdZJ6zybWBT4HSyesmS/MD/Du3K3o78cSzmSl+fPWOyzlyDq7hb1O9/+a7+Y6LBjQ5HOytCl8K0pNrUSHPsoyOamPU7rx5LF992PKBxLBofZZ8U74zQD/SnTbGSbcMaoD8nIAee8YuOHtJub8BG5OMsluazZBCam1Qva7IIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZ1mYYjrrHHoy3Jf3EvXj/lIUvn+1GWKER0kg4fa5Rc=;
 b=NoZ8pokodoCSnHhW3Bd1IGSLea3TE6mKDMghu3IDrogfeUu5wP6FXtL+1oSNfarufjs5A6hrVY7dEM/n8WcDPb73HslW7gXwCK3ScxZpZNi/RoUDf16MbrcVNzWvhssMKhSqXFi67Iou0mcS10b0qc02KDt1UlJnhd1Fcc+dQKJUkzbXJRHULp44gWwqy5fE2EY9bc0JW1n+6yUlUiuQfiRrM79PTPmV6mcBL20mpn8/ODRzHDVOKXPDQLfZyBOe31Uct3UTDHnuWPAPoa5tQQdMjy+k0I2tXry0SeUWQihmuY5aqBfNQtAMsFIUEYjl6q9F6InqqAF+bJ5IR8IqUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZ1mYYjrrHHoy3Jf3EvXj/lIUvn+1GWKER0kg4fa5Rc=;
 b=GggbQh+yrgIopUvVm5dZIBH8LKZuJe0kzuXfiSBVe0R9u3mrUFE3rPjVJe88Eunxdi+ygOfhOLxZ/aCpfjjWae50bFlXDjVPdcJpEQcW9s2DvZqc34uDtzX7FZcZs9KAd26aSJ5zLFJxQ8EMjzVaBCVjZZZ0J+odS7A91NZGSkA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4655.namprd10.prod.outlook.com (2603:10b6:a03:2df::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Fri, 13 Aug
 2021 17:58:23 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%4]) with mapi id 15.20.4415.020; Fri, 13 Aug 2021
 17:58:23 +0000
From:   Rao Shoaib <Rao.Shoaib@oracle.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, rao.shoaib@oracle.com,
        viro@zeniv.linux.org.uk, edumazet@google.com
Subject: [PATCH v2 0/1] Bug fixes for AF_UNIX OOB Patch
Date:   Fri, 13 Aug 2021 10:58:15 -0700
Message-Id: <20210813175816.647225-1-Rao.Shoaib@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0151.namprd04.prod.outlook.com
 (2603:10b6:806:125::6) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from shoaib-laptop.us.oracle.com (2606:b400:8301:1010::16aa) by SN7PR04CA0151.namprd04.prod.outlook.com (2603:10b6:806:125::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Fri, 13 Aug 2021 17:58:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dd7e45b-0b08-4131-efa0-08d95e83f18a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4655:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4655E6FE6F8C4F4C345A03FAEFFA9@SJ0PR10MB4655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ia5Lk/A60Y9yAo+akVrmgUuRlTJU0GMblWW9znwf/IshkP6Z2PmSegeBrKYXPpxHGMXIFGyndDAQTysf1ce0EcsDMYtMww8WvzAyJ1uDs7V0E8FMjrnaq6WjabJfbSM1lKoHUffMfwMq4KVauhSRUJgU0bZzh5md635VTBLvOr/mYtkhp3vOUooFB/kRwqvbkF+oqT0K8BiGszxtYUGNrpDk+LEp4rOMNB9mrET9toYIATqcyte+8PaZWzWd99xv78iDk2Hpb6OFT1HvVfduSfkzmZcVuLh+aC1a55Dk9ylh+FM06u7df9bCESKCKXT6cUXGzALqYhcHJ0falnhvIuo/4U+6+mWAZHPvntOU6KjZn7T5esSWw8KcxtB74KDnQFr3iAoPZUrIqRIPCluQMRGy6rjIdn+UC3jeexUrPPuXz00ouasgN/oDXV5NAc+zsrxPoDD4v88kRPqwgp89QoFXO+zunHq8nEteXOzJoSpTDxdYHEH+MiqsT66p1a833Z0jnOFF57TWkfQnsoFbzaDias0CfZMn8qZ1aSlbjeFMFWfKhloAHIYmCpQ7Ci63S0XlCbHZKX4o4EcG8S3KBXnvDVT+/sFtJVSuYAjFguZTBHPIx2DnkGUZZN9XDP1swnjTnJKxgocXLYmmJzTslw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(136003)(346002)(396003)(36756003)(4744005)(1076003)(478600001)(38100700002)(6666004)(86362001)(8676002)(186003)(8936002)(7696005)(5660300002)(6486002)(316002)(52116002)(66946007)(2906002)(66556008)(66476007)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+lq9lXqMFZJROBnEy8WCVvWFgN4/fDsUwrkT2JJAVnwgvb7ibIwxn8xRA4Xz?=
 =?us-ascii?Q?yeOiqyfUWBC8mAal1DW8o9Z71fzhinmg/c8jmfECqJFXqDzC8EsySZeqt3pp?=
 =?us-ascii?Q?pAHPGMQVuX7RAkJFCMoKRBywFjEjBRGao+IZ0WtxlUUG8JobZZBXz/lbE+sN?=
 =?us-ascii?Q?khBKAsndg97HK4D473g383Ub0XOtYZ0I1MxljmJlDTPmbum3prxOg6h07baN?=
 =?us-ascii?Q?Neh+WDkP2aBwzxXRHGGMu8ZXuM2nnrPzz/+DvPNHEDBqCLqjvWmf7GqebwlK?=
 =?us-ascii?Q?w8qMlg45lOsl4NueM0/GrlhAVkYlI+UTm6LOYgd+TEFyLk8UqxDZD2lTQFOk?=
 =?us-ascii?Q?GwYZX/voTGDFf+8tghEruBP8TqrQTSd6xg8HJJDvpWKoYpmA7prtkNV2Nb+p?=
 =?us-ascii?Q?JmWEOym8zS7SP/nGxcSAoT+ZnGMIcIgKp8dYJc9l7tKX7f25gVdq8ePcmtwh?=
 =?us-ascii?Q?TsN7ZRq5JuL4pLfSGNR41YR27m8nm4C3ByO/mPtPCjI8wMACDabPzqc+pCtR?=
 =?us-ascii?Q?5WNdBK6YFcb13pJrGT9JZl1ejnMp9/66igDvP2s9QeWmqQW0nfcNxqTOrRla?=
 =?us-ascii?Q?WEGz57Kr8PMtbAPPDCEMyZil8Wl1/G6oqd+I2t4uPswdqYCbkfdN7oep+5+K?=
 =?us-ascii?Q?8HG+u6MKVFv5SLqL9h0B0AvavkxQFDA7BzOj6Aa5UxsFinNh+MjR7nFtskDf?=
 =?us-ascii?Q?RqYT3q5fxvb2hyLRDU71VGk3rTEgPjX9lfJvSjl1ofuYGTN6RwMEa35LVVl3?=
 =?us-ascii?Q?/Brx0nDfDZ1Lc2hd4jgH4J7/HYStwG/29R+Q6Wi1EDqT2F3UpU6K+bXrIfUX?=
 =?us-ascii?Q?ehKbhqXgqqNPH6AdFo27hyRX910D6WRuD6IE4UftoMCI97I33356lHpEHBfn?=
 =?us-ascii?Q?oYrQA0WctS6c1jUsgbLo79ejTKlY5YnA8pd+Te9u3JNT8w+BRTY4c6GlYg/q?=
 =?us-ascii?Q?eAYjDwDsbyW0dNrFNKkXiQgPyvMyeJJ4rhZOkZ1Ec5c4ARf566nWfAsGeRbd?=
 =?us-ascii?Q?2x7FoSJwZOmAwMt+fRVCtwvubTArQCZ5vLM3QTXfw398oShhi9rU945bTPE8?=
 =?us-ascii?Q?1r/bTGz3/uXUG00Mwf0bzGqYt/O/bE7eK6Ab+yVrBVkceVLVpXin3yXF9MY7?=
 =?us-ascii?Q?WioVypdX2N9RAmi38run9o0cDuMdS420dTt5P1ma/0guSjvXOac5DjKL3G+N?=
 =?us-ascii?Q?k4TPrSTz5QSHj+Rv7kl/FfkJYsCQumg3eUBfmD9HMB90XQLqpeAzaLPZf5Wu?=
 =?us-ascii?Q?/6m6Ejz9O7HUgyiHKIoc9VfrOqaikmdECGsIlYbM00N8XG4Z4dTMP2mCl7YX?=
 =?us-ascii?Q?in7VC7/yUDjzU1hu6w8oYkrxK16LV7SDue2KyCn0kCjzE3NqvX94h0SJiIAA?=
 =?us-ascii?Q?mDiyziY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd7e45b-0b08-4131-efa0-08d95e83f18a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 17:58:23.8046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwCONjSJXdO4HlqHdMzIP2LKlvWbScagumWPnGKOb9z+MMEiex7H0hB/BJmPIjpEogEUyhobqIpypdnappvAGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4655
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10075 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=951
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130106
X-Proofpoint-ORIG-GUID: juUd__-NkQNuTKs1NG4QRKGqGjf04Nw8
X-Proofpoint-GUID: juUd__-NkQNuTKs1NG4QRKGqGjf04Nw8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending with updated version number.
Addresses spinlock issue found by syzkaller and
comments from edumazet@google.com.

Rao Shoaib (1):
  af_unix: fix holding spinlock in oob handling

 net/unix/af_unix.c | 47 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

-- 
2.27.0

