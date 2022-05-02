Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9558B516C7D
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383868AbiEBIxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380224AbiEBIxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:53:47 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2041.outbound.protection.outlook.com [40.107.101.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D69C55
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 01:50:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfNCHhAaIBjODFsvRILjcxwK5DDINDy0bGhx46oUcq4K555T+1saQs58JoGqxGbJ0ncHMdGasup/6WJSvX0xr2GB8TQjTlMY9Uej/R7e/+B8OMQOt+b3kWMKOWiCGSG/Yz7HgPe5+9DSQvLI0zp4TeSndM6+mvgsTfDxRFi5N6KWeMglrNuOUoNPAeCOXSswURqbeOSQf8lD0OZmrOxQDpWJSxptBHvk2e2oq4nLOoh9sPP7exCHxg/+rnXSUHIyozZw9CsBek0ICtQG3PCEhvsZlQHzmFXTeh4WfNbsGdmcvyrRKlbxDN5PulG+JYWrLc1OmfTOswKBxCtu0KPaGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anPAB3DYr5zT+UXPFymUTlFsJQ6jhNe9BVVRaGZVYg0=;
 b=HGqyurov3Dpqrwp3vfTy461vttOlsZgm5uILexat+1MDBbpkp0PD98KXti2tmra5PsSKqgHXGCtKnnvC6JgHPS7w7xGRZpmpNldU69/ZvOje66WnJD9G5kNuURP8JRkg82IqEu/DvtPao3THjTqpTQcqqrfwpC0OLo/dCXbhrur+tr7uxXqo4/Cjzk804sXtgAlFchBEfuQLquk2oJG/vPrL4z2E4kuA6KPXHbh2wXuz4TWd8m2uSzVhffQWxwGTkkGKO+4+NhyS2M6W+Q5O94U6DQ641bkO1gvCO9thlKI5N2GFQJRO4Ic4deGrbWV1OYCEMXLKimeJurS0TsdiOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anPAB3DYr5zT+UXPFymUTlFsJQ6jhNe9BVVRaGZVYg0=;
 b=m91rX+UVmvSa/X4NqLFE6scen1CrDwFlPV+uv2gMyWA81YB7JgHzEPYVXhANy4hiyAaM/DW+CsWEB3OY3GNOyUAoZ/9QNhDxCoVGlJfQiHUv6Z+StMjhZ1iTg+H5sDffeolBKfv+zqc7IIJEYjj/FRHU+S2Zs0jD+6Vobry5IeKNzuQGt8jssyjo08qbN5nnmlKMencTlozERH8HoKpK5JIbvgDI7COshoxXuvBVZU1+h847PiJSb5W8+0wvF+TFbhgED7eQwLyWjiu9sHQ2n7j/13Aa8DZvf5nVgsEHFt8ZrwLdTIC2K25jdfjT7GAu5Cl+spvK1pN8gAETJqeamw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB5912.namprd12.prod.outlook.com (2603:10b6:8:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 2 May
 2022 08:50:14 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 08:50:14 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/4] mlxsw: Remove size limitations on egress descriptor buffer
Date:   Mon,  2 May 2022 11:49:22 +0300
Message-Id: <20220502084926.365268-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0348.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::24) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee631a9b-689b-4d40-8dbc-08da2c18c5ec
X-MS-TrafficTypeDiagnostic: DS7PR12MB5912:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB591220A9F9FC239FAF94AD42B2C19@DS7PR12MB5912.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3RKx+SdWUGfdy2zv9Xpu8lVrfW+1G+GPRkzQEtnvNFeNf/kheHFtmmswZJAelpBK1kgBdhvE0YvC8s/yf6L82D+HcMqvigAyEbz6FXxRl/ijOeGyI7iNruS7aQTzmL51/oa7/sx5xxw7Gw5ScfK6jQlf9cz2bGKxXHxWHBktbYcaZ9Yizw1I3/ABQGPBAQRqEzF7cuZKuunERNE/TIrgsKEuYBYtWHtd9FJB+1WyrkKm0EgtnmjfVSeyUs/XywsxMQ+YrYouQrW1YI6xMKgPV+M7KTMOFUa8J9sXGtXCbVeYAnXNjAZ+CvYba7/eBLG0FcEyK5EAkwFahRcGjnLTllBsVRBpaCcyP0Z4r+YWBI8m457LPSjthqMrgUSHRoogM6aiAX6hriLns5yIa/gdBNvmicKM52nTUgzxRIrQjefmpvpXBtbTUhSODhQMaOTYnPVoXO8+9APGGoacQvqMMdVBDZBm0/Ee7YGcjD4sRTrEdtBeD97JpFnvtqtXKXRNiyXTf5JLRscrFPpeNSEZIBLnqoxvf0vi3VLBOuifAjai5ksJUXrxpm81eDKF6Bae0GHJWYLEfK2wZtmgVkk8KCncHVKgLwpFIwtQdvR0YYFxxGzJMVcphDmWFnb9X38r37OljGjf+uCOunswMqbhqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6666004)(6506007)(66476007)(6916009)(316002)(5660300002)(86362001)(66946007)(8936002)(508600001)(8676002)(6486002)(4326008)(26005)(66556008)(83380400001)(36756003)(2616005)(2906002)(186003)(107886003)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1bwETqwrYXmkfP5/OMGTNH48cCyvxrSPwW0BNN02eNTE2i0Tr/YVew0/lXR4?=
 =?us-ascii?Q?rBlfiOLRb18NAZlnM1a4DOb7nI0dt/5DmZnXR6JjPIAu3NRkogUxiUU/kLrN?=
 =?us-ascii?Q?v50xosP0wxFUez7ELLq4WzbaRk7E95jBYVJ4NvFJsbNRQEWJJbVr997gsKqX?=
 =?us-ascii?Q?kLe1Jd2MKNmRbdQ+y7OroJNN+cCBojtpsMoNFFtMdAFpTjZjpYAsKQTh9Qc1?=
 =?us-ascii?Q?tkV11boaKj0/oVefSYcy6axePw2Dd68jFPdB4DjeSU9dkNw4rUy818W7My1g?=
 =?us-ascii?Q?oZunOjrI66XDYnYm24mYQ8vVTNzS8IPAaVC5sz3FznPEUEujgntUVmC84WTf?=
 =?us-ascii?Q?CzedVbISas8IlV9CkV50tXTbijifE/wT3F/cUqQnvRW2i+TVL5EM1lbaERSC?=
 =?us-ascii?Q?5WKyFAaIBH40vfnp9BJ1feukOXF/3RGLOr+v1nML3OZr7+7mDIJ+Thz9Pc4+?=
 =?us-ascii?Q?v0e4x3A6yufqK6FYebHtR3EatOLZQ3PUhbplbPgI7Hb5xVpJQWVK5ak5fDTP?=
 =?us-ascii?Q?NYm6CL/O6T1iuzaQnFHGa63PdoBkQTdCPE0OZ0MlpVaSvPOo05RLveWTAKFO?=
 =?us-ascii?Q?zPrk5+hleHXh2yqg5OkaAfqO9MK/0ml8LKRI57MPO/XtZwMkQY3XlEuMFlbv?=
 =?us-ascii?Q?5EXNAKS+AvvpLm+Rjh81gf0SiG4NI5pZXF5xcrkrHS28Zp+jK7X9BpT4ejFw?=
 =?us-ascii?Q?uQIOR62oGmaU3WRjrMn8R0GI5FOSpu/z6tUoe3KhUEf5Yaa6bfzIh/OyzIWI?=
 =?us-ascii?Q?+R1a5DpoIGqnb5FCwjCGtm6eOt6fRbBsxhSaTMI0m06cHWdV9R4xF95DTnCX?=
 =?us-ascii?Q?hOh3vsTNGqC423bJDx0nef7nbE0oAlCuvS5rkCJu/7A3V51JdS5UpL8kinAr?=
 =?us-ascii?Q?gP2Wdkr18J0DCy4N2ZD87vJZCQSyAjKfKFu+1h2gSpQ1w+8kRFCwS0PmC0nX?=
 =?us-ascii?Q?gY7D3BgFgN86uN/y41rdSG6WgHXcP50svFd4Mddeu8+LXhhDWUsLcuHAKxhi?=
 =?us-ascii?Q?030cz+y+TjQXqKn3IwOrX3CDca9q2VBlvNQkmZdaNqmw6+AKhprnzm6TL8rI?=
 =?us-ascii?Q?M2bZ2U8+WT0D8M1EKGXtQZsOkVrR/Ebm5GA22slP2jYjA+GCf4HRR45NJiwp?=
 =?us-ascii?Q?bf3wbh1L9eat0PJJRO/3c7kAw2yFrZ/gT7tTkLljjrK2s8HIgnhleoOqkbxP?=
 =?us-ascii?Q?NLTd+UDUBsfm5hV7i4r/IDtSeQ/eM+1nPh2SIZUmbzAnTcublY+M85AB/84a?=
 =?us-ascii?Q?019t866DJMu3YZGd0GIuieQOH/NPxykVJzHixGf3RZyU5HWvld3DF10+fS1t?=
 =?us-ascii?Q?Lj49pZDBlxLcZdmwsh+HfyvfO+Zcbb4rjj5xsR68ReMyWVlFgWuaNS/1R4o2?=
 =?us-ascii?Q?2g+FDISXsWCktnXRnDz0HNT7KgO4xDQv3XElvzk9mtG1q3+NUzmyN9q7kyMX?=
 =?us-ascii?Q?pzq/TK5tJE1yluikn+WezVsB0Y6tzqwUhcVHYf/v7Pj2Yo1wcPJ+NFBNbCQs?=
 =?us-ascii?Q?KcNLbXMgdSSURWkSq83esIUl6dKwn6vmAmh5SWzr0QR0RGDOCP4b5M8ysSZZ?=
 =?us-ascii?Q?TMFmISU+xukta1sGFtF7ncMARk5Gg1XGNP/Ob9s3fhMLAN07fU++9JJSdG5o?=
 =?us-ascii?Q?bRI3ulWiL7w9HGNOsGlkfHRzGWj/C91+Rp83NAMGLo45x8gRnIcMV8LMYcuw?=
 =?us-ascii?Q?J3PnLlVPhnbZGBx8R38Pg21RhDwfL5Y5fqDy0SDsoekLjy12ZCdSlLA6oHek?=
 =?us-ascii?Q?9g7Rk1VYww=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee631a9b-689b-4d40-8dbc-08da2c18c5ec
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 08:50:13.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OUEPsU/gt1R2xPrLurGk7yO4ZvA0qyM/sabo+wPAr/RrcKfUghbWswfLIAGqz741k3GO/k6uhh5L6oeA8rYfIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5912
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr says:

Spectrum machines have two resources related to keeping packets in an
internal buffer: bytes (allocated in cell-sized units) for packet payload,
and descriptors, for keeping headers. Currently, mlxsw only configures the
bytes part of the resource management.

Spectrum switches permit a full parallel configuration for the descriptor
resources, including port-pool and port-TC-pool quotas. By default, these
are all configured to use pool 14, with an infinite quota. The ingress pool
14 is then infinite in size.

However, egress pool 14 has finite size by default. The size is chip
dependent, but always much lower than what the chip actually permits. As a
result, we can easily construct workloads that exhaust the configured
descriptor limit.

Going forward, mlxsw will have to fix this issue properly by maintaining
descriptor buffer sizes, TC bindings, and quotas that match the
architecture recommendation. Short term, fix the issue by configuring the
egress descriptor pool to be infinite in size as well. This will maintain
the same configuration philosophy, but will unlock all chip resources to be
usable.

In this patchset, patch #1 first adds the "desc" field into the pool
configuration register. Then in patch #2, the new field is used to
configure both ingress and egress pool 14 as infinite.

In patches #3 and #4, add a selftest that verifies that a large burst
can be absorbed by the shared buffer. This test specifically exercises a
scenario where descriptor buffer is the limiting factor and the test
fails without the above patches.

Petr Machata (4):
  mlxsw: reg: Add "desc" field to SBPR
  mlxsw: Configure descriptor buffers
  selftests: forwarding: lib: Add start_traffic_pktsize() helpers
  selftests: mlxsw: Add a test for soaking up a burst of traffic

 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   6 +
 .../mellanox/mlxsw/spectrum_buffers.c         |  26 +
 .../selftests/drivers/net/mlxsw/qos_burst.sh  | 480 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  21 +-
 4 files changed, 530 insertions(+), 3 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh

-- 
2.35.1

