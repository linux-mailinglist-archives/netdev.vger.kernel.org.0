Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236956E4716
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjDQMDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjDQMDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:03:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::71e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8107D84
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:02:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dHrIdWU8ByS1NEpOAvU233FFs5cwaS7HL3y5Wq3CrmIHoovbCA/WF9WS05TyhQrxNbQhVQEOetpc7kYuXcygKy5IG6QWZitVt6WLV3xFo4bE8PblsFp6pkBygCsz0OGtGGmbGKSD3W0iXda//mkYDwNecFhEx+W0XidC2MqiYOEr4nt41J0IqNAR5Nd/CgoNwAH7LYz0MyOBA/PXMZBmlBPjQC7y+C/jmWvn5bRTimMfvFcADgvtxnGgEzDf8RP2lFhdt22bwvw3qZE2FyNggLIzMxg01aSIm8s4x62RL45tIieMV91DTqJ7xtM1U58R9+8EMwciKtEgjbaf0MVpLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7jnIKYWCoyojZcvek7BIecBdehhlCYFntyq+sfi5DQM=;
 b=QJCwRn9A9RlcocDvv0bXYyODBZlVIy8H5ybC5D9eFvew2DNSbVKZ6hyH8L22Co/ndgyuFgnPgU3igNDpjDDCFU5WJY+lnXCX4QOop8SnocPzFHg+2+jX3iV4c80f3v6d+gwRUwdGHsNQ+CWTijcnD4xmIFP/Uisck2BRM1SxKjesBmkRr53+CiUBjoIPZXN8yKXiH214niHsHvNtyBYwJefKRt2ohHmxclOxIS452XqZ+YnlrTI06UkCARWBS0Lfn3o8n7e89dyxluHbrPBRuDFS0/vMLX35EEUPyc9Ik+exC+Yx+h/00/HS06k1AksoApUIreu1fMlKwTppVY2IVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jnIKYWCoyojZcvek7BIecBdehhlCYFntyq+sfi5DQM=;
 b=RHDG538QRKTkf/ECV/ObLyFwauqveOeB8SIo6QhEjkX/c2UUeBKKDWYLCWvYu9vAEJv8T6js4LnYBi+WFyT5684Jm6VRDt0VHfZVmmRrvGAyVG4dzfcR7PlBT7Qh+UFDOURKjrhu/L/hOcS8Ka+XXmo0oG1vub9riwLuL+rVzlk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5219.namprd13.prod.outlook.com (2603:10b6:610:fb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:01:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 12:01:53 +0000
Date:   Mon, 17 Apr 2023 14:01:47 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Michal Schmidt <mschmidt@redhat.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Karol Kolacinski <karol.kolacinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Petr Oros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Brent Rowsell <browsell@redhat.com>
Subject: Re: [PATCH net-next v2 4/6] ice: sleep, don't busy-wait, for
 ICE_CTL_Q_SQ_CMD_TIMEOUT
Message-ID: <ZD01K/CP8llU/Opa@corigine.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-5-mschmidt@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230412081929.173220-5-mschmidt@redhat.com>
X-ClientProxiedBy: AM0PR05CA0084.eurprd05.prod.outlook.com
 (2603:10a6:208:136::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5219:EE_
X-MS-Office365-Filtering-Correlation-Id: 32d6e470-fe76-492a-9d80-08db3f3b8894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0qRS2OsqK2qyanvi9s06qERLlCUe6VH2YpGAGEWY4bKKFmTWOxdOUvzDoY9YyFA1pdHA6ySr6mILEiSAtr7nxMIo0lmuItAeRA62+iOvT66oRcUbN2wOLAJ25AeQyPXYiVkwvhzwcN/25ANZ0CO3xmx/1bjGlwyMn3Ygw4lp9ubvh5tHuoHv7BRDqQTfYFqEqjr1F9KDE5pFN4n7Q+Gpk5GfcEvxXsvsZVOseCzDoTnDQCa1SvYjauNPAatRBpl4m7aRdrHjncaJbH/vMft+0qnAzPX3BM0obKrgbVc+FAUkILugG4XkQDn+lIc3Ah7QWiZeJPcAJ0hVgennEd1fZQYCfDjqMSZFDgUXaAWwCt29wiiSA+gR/7lCWHah4qZfbUHSSDCGdL33L+lftBRy6q3CYO57Extf5Y03Q5woFqlroYZjkRKab7oFUHzzVQptPbgGEQ6GjGdv9+ORbngcf93az7WcvWhzRJDkkcM1g5+L80sZ/gWCIahQ50fsw1P1qeeYCHYfH0D6u3kzpa/IDWxDZVMZf8XuZcQvrPnj805N+VTs61HIAMqyXQmdfVbn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39840400004)(136003)(376002)(366004)(451199021)(66946007)(66556008)(66476007)(4326008)(6916009)(478600001)(316002)(54906003)(5660300002)(8676002)(8936002)(44832011)(41300700001)(7416002)(38100700002)(186003)(83380400001)(2616005)(6666004)(6486002)(6512007)(6506007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUgxdWtua3dhdTFCOVlpOFZhdzdtNlpaNGlTRGhrcVpIVGZoSjd1SlRCSGdU?=
 =?utf-8?B?MzJpOXZFTVl1VlNoVHUyUEdUelVkYkw1OVVVUUFONFpFSFVCdDArK2RLNkxT?=
 =?utf-8?B?TVQrSUtIaE1uMGhlUFd5bEdMOXNpSFF3WU9kaWJMNEJlZTVOUXRUdGY1Vktz?=
 =?utf-8?B?UzdHcjY3MVhvcWNxVUNaRmVoWS9qSGJtVWZHdVZRL1lSUXR6Si9UQmhGT013?=
 =?utf-8?B?V3BaMDlNY2I2SE1QbldwSWJRb29iaHduaGIyN08xam5YYmNuOHZNWGg2WG1Q?=
 =?utf-8?B?SlB3S3k3SndKbjQ2dVd3amdENnF0dGVVMzVyd3Y0WjV6dEQyQ3RBNVdic2Qx?=
 =?utf-8?B?ZjkxSTdKZ2JPcFlvQ2p5REpvV1RCcmNYVlJ6d1JCa0N4d3d6Z0lOT0MzSVIx?=
 =?utf-8?B?Y09JNStNUUtMdnVlR2tFWUFQd01ya2Z5U2JrNDUzV1h4T1pGZUxuQUQ2aG9k?=
 =?utf-8?B?M2trVDl0Mmp3ZnlCM3BQNHViVm1GU3kwRXVQSFU1M3B5Rmptd2ZMa1owNEVQ?=
 =?utf-8?B?T25ySlg1b0lWMmhvMkwvVThjMXBreXFVbGhicjBYMkxEeXRxQnhuWkdzM0Jj?=
 =?utf-8?B?UnJXa0JEc2JLQS9PK1ZITjFPYUdsYmdicVR6dVRRa1E4cWMwZXZKZWliVVIw?=
 =?utf-8?B?bmdXaHk5aCsvQlp1YWl5ZEJzZnY4akZGWmhyb0tBZDhGbDZkM1NNNFVpQ0M5?=
 =?utf-8?B?d1FCQVkrcE92ZjJ0UjhqTG83bGhEVkkwVnF0TEhWcTBJNjFLejh1M1lwTEZs?=
 =?utf-8?B?bmtHekJKMVhCM3J0aFhlUkNOcjF0M1ova3NvNDliUkc1b1A4QUJtck9XZEJL?=
 =?utf-8?B?RFFsOURrT2ZmSFUzZzZ6T2FFNUc2R002L2VvN0NxTk5HbGxxSS9SZVdlRXpj?=
 =?utf-8?B?SmM4bXNZM3JHVm5kd09Sbi9zaTNYUEtaSXErK0lQQS9YQy9OSmZpbWxhTm0z?=
 =?utf-8?B?c3JhSGNkUmVlOFpJM3FkV2xYMHlrbE9hYTZoZFc0aEIzYWNxbExTYi82VVNq?=
 =?utf-8?B?bzQzUmp5TDhEV0s4Z2ZTZnMxN3c1QWxQSGZ6YjROcU9EN3Bib1orc1ZCRTds?=
 =?utf-8?B?ZDJhVURneXFSUU5zYm0vRDZkRUlBS0hxYlZwV21ReFJWKzNuaCtUVnVVVWJ2?=
 =?utf-8?B?Z09YbUZSVmJCcVZneVVIYWMwZnJQYitDR28zSnM1a0czSyswek4rcmlQb3RW?=
 =?utf-8?B?eHVpa3hJeTFqSSthb0syS3dCVDJpRzVXWnlpVWt1UGZ3cUs5YUFmZnRhWVo3?=
 =?utf-8?B?WEQ2RytHaUZ6dFk0VXd4N0RNSnJlSlN1SXVZOW9LdUY4dmZFOXRrZ3d3MGJO?=
 =?utf-8?B?RU1WQWpvZUtNSSttYlVlV2M0YjhlZDVyZUQzUTAyQ3Zib0l3OUFhQ0IzMW44?=
 =?utf-8?B?ZlovTTFwZ2FOVnB1eWFabXNuNE0wK3ovS3I3UllNa2ZiTG8yZkxXZ3JySTFs?=
 =?utf-8?B?KzMwVENUM09MZE1ZUU96Um54Y2VPZjdlWk9SdEJMQ0hUUDFNaEE0WnVPbDhO?=
 =?utf-8?B?eitGMGw0ZHBZak9VWitKZVBMREErRGRwNzFGdDZTSUlJTnNxWGYycSs0OWFF?=
 =?utf-8?B?TjVIT0xXSzFBZDJqOWNTSk52LzhGRDNUOVVuYURqWjl1YnhTdlZjTURVbkR0?=
 =?utf-8?B?OENQR2JnQnl2ZmRQYUFEdm5vV0IwSUxFUzVoNld5b2xzcjRTbzdWZEtNWVlr?=
 =?utf-8?B?Szd0S2hweEl3aDFCdTRSUzNYOTQ3KzBqdlBqRFEyb3gwVkloQXQzaXBFTGpQ?=
 =?utf-8?B?M2pQVWF5WlZYUnNjVUt5R0srZ0dOdVRsUjBWdU9LTXYvNzc0eUtLSi9ZUXhv?=
 =?utf-8?B?RnduTUhmYUlBNE14TUd6YWxTRU1Ga1N1YVJTSXMwVEpGc2xabEltUW03Y3JW?=
 =?utf-8?B?MXVBdlpsN21pUmVWWVp0YkNIdlNQZ01vdVozTjBjSXBSVGNnQStwWFQxaDJr?=
 =?utf-8?B?RlVyaGVYS3hoT3Y4bzcwdkVCSmpBMjR1QXFmZkN5N3UxNzR4Qlg1SEFidzhR?=
 =?utf-8?B?NmlIZkdCVjVqTWlxYjA4VldlczFicWtmYWxDa284WFl3cW5tUjlPNm9MTWN6?=
 =?utf-8?B?QkJkOE9aV1BNU1NuRU81SmZJbzJrTnplRmlQQUVOUU5sQzh6M2EwRWhnbFVT?=
 =?utf-8?B?MEdvSnZXYmEyVlBvZG1FRkJOL2QyekZzeThTS21STE1zTWkvQTdZb2dSeE5W?=
 =?utf-8?B?QS9lNmsyRVBnRkRPWFJCR2o3dXVuc0RhbWNhQ0FuQVAwZ0hRSXRkS0g3Smtq?=
 =?utf-8?B?bXhiVkh1SnA1dzlneGRXNWd3eFl3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32d6e470-fe76-492a-9d80-08db3f3b8894
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:01:53.1354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mx3cYy2x+fPvwRU3VPzR1v0YbaBzCPrsS0cMqtrMJwT5zJ7+jMvUb1EBDX6+icqdypdzBUwwkJdXh1zidSJ5TM+66T2ZdD5ufao6DX8C/CU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5219
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 10:19:27AM +0200, Michal Schmidt wrote:
> The driver polls for ice_sq_done() with a 100 µs period for up to 1 s
> and it uses udelay to do that.
> 
> Let's use usleep_range instead. We know sleeping is allowed here,
> because we're holding a mutex (cq->sq_lock). To preserve the total
> max waiting time, measure the timeout in jiffies.
> 
> ICE_CTL_Q_SQ_CMD_TIMEOUT is used also in ice_release_res(), but there
> the polling period is 1 ms (i.e. 10 times longer). Since the timeout was
> expressed in terms of the number of loops, the total timeout in this
> function is 10 s. I do not know if this is intentional. This patch keeps
> it.
> 
> The patch lowers the CPU usage of the ice-gnss-<dev_name> kernel thread
> on my system from ~8 % to less than 1 %.
> 
> I received a report of high CPU usage with ptp4l where the busy-waiting
> in ice_sq_send_cmd dominated the profile. This patch has been tested in
> that usecase too and it made a huge improvement there.
> 
> Tested-by: Brent Rowsell <browsell@redhat.com>
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

