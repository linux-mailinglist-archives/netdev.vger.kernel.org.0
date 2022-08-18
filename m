Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF79F5981E2
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244247AbiHRLDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243983AbiHRLDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:03:20 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50102.outbound.protection.outlook.com [40.107.5.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019C8263A
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 04:03:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d64HNZWaFpG5Z5S/0I44mnjYhmJUffh5NwQYuO3qhlItmDrOBtKDuumQuIlAMX6hS1UcXky1DZDUnejGVFU8qzS7RHyVwlvvVb3Bof757iRlclMwihtsHJDH7e4HLRqkxSoP+Dk4GNypUOr9wWKMYU240rbRTvZcw/T8gp9tIO2YO8KCqJp/uuns4KSnhAB5qX8+rWN1ciEMYlPsz3AjWiBIsR/F7jNniU70EYs3Yadpt+picoIlJ4nOLbP6YQE389QxrHV7vXxncvmIC+x0eG4pwvYf7cn8dmuxUMU8qT3AYhql1sUMpmNGJzUvccsPetUwg0XuBjGbsV/nRXCqPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayRF3hqhXCA+9Vow3h5tGmoZ7kzJw/nzCAAA5gpXqSM=;
 b=JegrnBYfe5XE2x/gTZVmkT3e72bIfYnMYeMG4S1AJI11mfhyj1XueRbVr8W5SbwxG7xJs/CJ6Cd5aBIhSloaI33+qN1tiLzJ2C8zmoUImKLMdgC7OfVJ/911hjFO6OGEaPeCATqQImgoqtw5svyvOA9Meu/j8LyO2eZwBHj+6v1C3YjIng1X/NcSlFHV56jxazhDaAE1wHQXtLz5D4witaWp2v08mFJovvmE2UY2R6w4KMi6VEf5zmb5fh7feAGljnhIcxRuuI566ucyH9A+QAmSgPfdjkqJm45FOs/8T1HngIX15TzQ5398RBikmIIVO6ta04MpCkU5ycUpzDVVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayRF3hqhXCA+9Vow3h5tGmoZ7kzJw/nzCAAA5gpXqSM=;
 b=jKJ480ZbEj21XJ6IgxhQtjulx4j3NfuD/1RggLclTLoN4a1Q9HFX+Et480JcwXD1+/iVk8dQ4pOzFjknJ+6yL+pUacWcoAGHILg/GWDHJVFyrKR6YlM+Cxu/8pIsBsf3tqXldHaX1Cs1Dg6hVFBELEUDNDkhyAPRH5yQqFRJZCM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prevas.dk;
Received: from DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:34a::22)
 by PR3PR10MB4128.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:ae::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 18 Aug
 2022 11:03:15 +0000
Received: from DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::84cd:fa2:ffc0:456e]) by DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::84cd:fa2:ffc0:456e%9]) with mapi id 15.20.5546.016; Thu, 18 Aug 2022
 11:03:15 +0000
Message-ID: <408851bb-5245-7a10-3335-c475d4d1ca0f@prevas.dk>
Date:   Thu, 18 Aug 2022 13:03:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Network Development <netdev@vger.kernel.org>
Cc:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: commit 65ac79e181 breaks our ksz9567
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GVX0EPF000013D4.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1::10) To DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:10:34a::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b838ff4-a506-43b0-a6e2-08da81094015
X-MS-TrafficTypeDiagnostic: PR3PR10MB4128:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2xlTV3Kl1qFjxeXeQUiQOmLuWLqAePk0JrvNmTo1fIbW1O4Zc/4NdYBBshOHF9ewE7aviwmdN3RrX3foo7o23428Gh3+TqCCwleWferbfwgcIqIs/EKehfb+T46PYccPZsKnGY59ySfv0CXwk7MtmrJDT1LBmLRWRZPlObRYbbDyfmBOVCpbqx9loFtNw4XfHLSr8NqIrIyyRuEua0MNsSQLIAjefkeGBh1SMxECH8es3vD4T/9fopWQfhTGoUKSje+KGsfud9Oxlf8J/xQWD+lLAeUtEBjUahgxlmcQMDhm58MxNilug/JYt3imxuhxfQpkKsgHv7kPpZoduT0ReJNRtWyHEguvoQAsDAUfN9JwlA7kOT6RTH5oyLLYULHsiE+sTrk7i4rj5RtuWrtDItBsEgsmVwFIYqfGcdqc2xQea2WJz8c48q9JciGwhWm3QeXTpc83PN3O9JM/n0aFTFP29SYf1GqH8cv86cfg3rbBUCsoLFAwKrUaSEPTxYGkogKZWwFdDJ2XyabuMzvuIdDLKp2F8JfjeSbrcy0CWgnZLhLEiBhHuaIv600gth2SIe5vIYEUN1YiwEpuB6a4n0p1OJyiroiZboKxZbGQziyhsnhaADfy7DP+5z16EgDIhxJK64b33IY1XO/fG4oDCsAPp/NH+Nq/pwCIQifiu+8+nIbRZ71JC2T0hmiG7fw5djv2n4FwAPfAqmjhQaoW3NeVzQEuZFapB+XWllj92JyV/0H7lgVTUDJZW5SxkuFeX64O0hYtY6D/NqXG4UlLXN8JR9He5P/m6/3UsOPVJK9Bg5rhFwKFzEhcT5OiaxEb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(376002)(136003)(346002)(396003)(26005)(186003)(6512007)(52116002)(6506007)(41300700001)(6916009)(54906003)(478600001)(316002)(38100700002)(6486002)(31696002)(38350700002)(86362001)(66556008)(2616005)(36756003)(5660300002)(8936002)(8976002)(44832011)(4326008)(2906002)(8676002)(31686004)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFlqQkswQVlHazBPK2wzZDF5MURSa3k5c3g3dm1jL2VlSHUzWnp3RXZRS3Bu?=
 =?utf-8?B?aTJPTUw1aUhwSlRxTy9raW04cEM5dEMzcEJxelNudk5CaE8rbWJpZjBEcTUz?=
 =?utf-8?B?S3ZpQW5ZTXZnalJMR1JDeW8rOGQrb0RNeHdJdGtITXA5bHlNUGFjckd6VGUv?=
 =?utf-8?B?dDNMS1BpOHdSZEdUdUFvVWFYVnlPbDdMQ25iRExtNUIyNWs2QzBXb25wM3hE?=
 =?utf-8?B?cm95UHhERTRMR1dVMEpwYzR3TCt3V2VsaXNTWUt6bXExbklZVmV6b3dobXFH?=
 =?utf-8?B?eE50RmhGRzdqek81Z252ZncwZGZGQjNrZ1pLSTZic2FheWFGZlFTOUdFbWJI?=
 =?utf-8?B?TjJGbkt3aHpIZ2xodlVqSDJGV3BlRGx5VTQ1em9oanV0Y2pTYXZsallJaDcw?=
 =?utf-8?B?aWlOaTUxOERkUldmU2pnS0VCNnNWV01DR0l1K1NLdEREbG1SRWFldVBZSVpr?=
 =?utf-8?B?dXVFMWloVCtqUlBxU0xsYzU2V0JYeHFtcjhPVmJjZllwbW9CODFWUllxbWgy?=
 =?utf-8?B?eFNCRWF4ME5SdFJ1Mnc3RTVGb05aaWpCVXlFUkJaTTlCSWI0Q2RzMEFhMkY5?=
 =?utf-8?B?OWh0eFQ2VDRyZFJyUkdwSDBaZHlmOGhtQnRmdGJ0OUNvSGdtVENaeXNneVRi?=
 =?utf-8?B?UDFwRGRITWpFaTNoSkFlRVdCdlRTVzFOeDdFNWFJREF5ZkcrcUZlbEdVWjc0?=
 =?utf-8?B?aGYwelJMVDlYTytkWDE1NlJ1M2lIeW90YzVuYTZWZDNUck5LZHhIUkh6anBx?=
 =?utf-8?B?MXdxOHFMUmxJQXlHWFZQQzBKUU1vb1hwSCt0MDlzdnM1ZDkzbDZKcjVFSW1n?=
 =?utf-8?B?dTRkTkxqRElCWkVlRFBGRTVOd21SU1AyY2NWZS9oSUI0OEkzZWI0OGo3Ni9l?=
 =?utf-8?B?ckQ3KzRneFExUkZYZ1NoMDl2cGliMmNmN240SjljWVBVSUNqTlI1WHZIWTkz?=
 =?utf-8?B?eXBaM2FTWk1mVE1iZDNiNkt4cnFEVmpldHRVZCtnVXR5VUpneUxKRzd0aVpv?=
 =?utf-8?B?NkxQdGNpMUMvV2pCTlNEbWsyUVBjS3JySHlyQit6RFR3ZWx0a3FhL2Z6MGdq?=
 =?utf-8?B?MTIvVjV0NEljQVRGREozUVcxajZHZ1BvMVoyUHJINHJ2aFE1TDJMbkt0R1NR?=
 =?utf-8?B?THh0QzZPOGJhZ0JoUGRzSnpnTWx0SFd4TjFLeU84aC9ITks0TWhqK1lWZHFy?=
 =?utf-8?B?TGNOemRDc3E5NUI2UmE1SnFlZlZRTVZRWm9DZWMzZlRSY3JPMGNDSnFZR3Av?=
 =?utf-8?B?NHdld0FWNUowemJjUUpQZGEwQTZyOGkwRU9OWmt5SVVOYXpWSHB0STVKYVE3?=
 =?utf-8?B?OURvamc3RW1rRVlqSjlQSjYzSGVHczlUZmFBQ0NwTlRqNmhOUW1DQW5uajdV?=
 =?utf-8?B?bUpKNWhDLzNEcnNLYzloa3VtN1laTWtZVmVKMDNXNzhwbWRXckNPMTRudjM0?=
 =?utf-8?B?bDc2V1B0elBSb2VqcFdnRXVNWDBoS2IvcllNdGNnRW5sQUtqay9tUmVTM2tz?=
 =?utf-8?B?enJtR0FPNXM1WVFmUm9DNTd1WThxa2pvdit1T1h5YWNjZEpacFdaQUd0ekc5?=
 =?utf-8?B?UlR2UDUySkxweEN5bzRoU0JEYlhIUlZKeHJXMUgwS3VUdmQxRzF1K04yNnA0?=
 =?utf-8?B?SmxleWdRV3RKZjhTa2owYnEyZ1k5dU8raFFoWm9MeDFDOGlIWkpqVWF2U1NW?=
 =?utf-8?B?RkZ6RHNhdUprbkpBeHJTTWwvMUNjd3djR1RJSlJ4ZnV1V3drNkpaUUFTOXFO?=
 =?utf-8?B?K3ozRmNxR05RNHo2SFRwWWdZTU5yV1dPZXBlcjRqQnRxc1NQbW00dHdod3Vy?=
 =?utf-8?B?eGZrTXk1VG9QazhxK09kb2JWOE9LVE0yQzg4OEhYanU0YUxadHhiYkM4cWZj?=
 =?utf-8?B?OGZGTDNoRXNEcEptQlRxRkFGSjZZczlBSm9RZGZWTU1rcmlUNlpUemVPZnFh?=
 =?utf-8?B?c3VNbEdZUFNldW1vQS9TU3VMMWF3RTZOYkwzN3Zob0I2THZxOEJKTWhTUGE2?=
 =?utf-8?B?Skp3cklpK21QTHpXOGJuc3lOYmpzT3RGY09EQ3loenBIMTkxU0p4NVN5Uy9U?=
 =?utf-8?B?U0JYNkFuVzdQTE4wQjB3OFQ4V21YUEVPK0dGZ1QyeEN1MGZtWkxZRkwzREZN?=
 =?utf-8?B?YytzbktKWDY4VmRJL2xpTVVMTWVRYkVqUWJ2SnR4TkJMalFtWUxramdTbTdT?=
 =?utf-8?B?VEE9PQ==?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b838ff4-a506-43b0-a6e2-08da81094015
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB5266.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:03:15.7445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iA57EF9SZKWSlnb6SVhokxhI4/jtIGvU4EiQ0vWL8nV2XHIHietUDMHDNRdxRSZfYXMnVw82C+yQbYtdKQSJJWI7lbftbz5UFWyO9hzD0j4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR10MB4128
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a board in development which includes a ksz9567 switch, whose
cpu port is connected to a lan7801 usb chip. This works fine up until
5.18, but is broken in 5.19. The kernel log contains

 ksz9477-switch 4-005f lan1 (uninitialized): validation of gmii with
support 00000000,00000000,000062ff and advertisement
00000000,00000000,000062ff failed: -EINVAL
 ksz9477-switch 4-005f lan1 (uninitialized): failed to connect to PHY:
-EINVAL
 ksz9477-switch 4-005f lan1 (uninitialized): error -22 setting up PHY
for tree 0, switch 0, port 0

and similar lines for the other four ports.

Bisecting points at

commit 65ac79e1812016d7c5760872736802f985ec7455
Author: Arun Ramadoss <arun.ramadoss@microchip.com>
Date:   Tue May 17 15:13:32 2022 +0530

    net: dsa: microchip: add the phylink get_caps

Our DT is, I think, pretty standard, and as I said works fine with 5.18:

        ksz9567: switch@5f {
                compatible = "microchip,ksz9567";
                reg = <0x5f>;
                status = "okay";

                ports {
                        #address-cells = <1>;
                        #size-cells = <0>;

                        port@0 {
                                reg = <0>;
                                label = "lan1";
                        };
  ....
                        port@6 {
                                reg = <6>;
                                label = "cpu";
                                ethernet = <&ethernet3>;
                                fixed-link {
                                        speed = <1000>;
                                        full-duplex;
                                };
                        };
                };

...
        ethernet3: ethernet@2 {
                compatible = "usb424,7801";
                reg = <2>;
                phy-mode = "rgmii-id";

                mdio {
                        compatible = "lan78xx-mdiobus";
                        #address-cells = <1>;
                        #size-cells = <0>;
                };

                fixed-link {
                        speed = <1000>;
                        full-duplex;
                };
        };

Any clues?

Thanks,
Rasmus
