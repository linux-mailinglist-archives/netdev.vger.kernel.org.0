Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18C54F1874
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 17:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356757AbiDDPec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 11:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiDDPe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 11:34:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15143E5EA;
        Mon,  4 Apr 2022 08:32:33 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234DlFtp024455;
        Mon, 4 Apr 2022 15:32:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=GJG01eud7SPlKsntQsGcxaR1H1LOQ4LN2oO2c59voCs=;
 b=iGPV24Ma6JaEliQJ1b5wkdVkRrU8TBQIS89Fu6hbQJqbi3tuZK/uzwfyTnExeSG24XRy
 MuR3bdBJa+CXoTJQWpSIgtt3Y6HhiIBTyyBcb0EJkx6FnjBuygYBlztgcYfXF/Gukx8P
 eAXV42QaDg96+xcKN8tLEB7TPmuTraaCcNqvZKf9xI6JIqpLx565hL2+Xwy+FuSuDQ66
 zEwors7pzfIwPoRQ6at1YWbFCfXlKYQJj1bETkUktPiqIQQYjRUhoRcUyWJxdFIDBBk9
 dt7KzLXtP8A5jOzT+8Nn1yUufJdsEA6qGI5OMaYsCoPAfQLJNsQj0+hnHVniFgeHxN3V vA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1t3kfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Apr 2022 15:32:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 234FUk6s034514;
        Mon, 4 Apr 2022 15:32:20 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx2kc4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Apr 2022 15:32:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1TNzp5cTlxgz1l0rON0DMla/X3rg6VYXJok71140ugwO9l0eWWl9Nt/YoD/WaR392vvDsNHARR7lumVTcXOQ0KuJLsnlTQ78ejZhxSLYXUIe81gWRZr5wpzMfaAk6rBUMDf28fYB8mTltdayAUapsOyS5Z/FXlD5TBdzXis4dnLBvIKDTYnbrZN9019uOsIAMfqzdXBZTXY4zcLN+hgVEWwfieTyxHKBNXu0U1yPXfKnrqjuSOp7IBvyiRt5TeVYWwHr7Tsv7hl9H1Y2Pm4gMd2IKScS2j5XMeMOAq+vhXTrgjoYXVzCiXS/KwtGJWiJr2ezfHDMKb3Cdm9ZbPwvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJG01eud7SPlKsntQsGcxaR1H1LOQ4LN2oO2c59voCs=;
 b=HhN/8G8/TdCnfT5Om2/8oonKVUiMUQlm8CVvCtzhRQAkGE5Lug75AOvMgth4ZELxWuiDkreIvBwjHvF6pRut2ndvNV6ed+bJUDNYVs0praQGYAf/swbEnc4eXWMvjxnLq3mGRJi4B6vBG9AGTBSH+9Zodz6GWttsO4pz0e+vWF7UxCtrcH+HdOGUNqA/wLYeqxxu8nPR+aZblW1tpjKG0nwBcls3UEoj5N/ubKDYkCLfqnh2mEBzm34SYjfDLwV2w7xTFNF3Q6dQxpmTcEwexmFYf3DJ7ik5B3HTF1VDNKYqRHCYbBkb4qJV8xzc6CyMmi81MoeyFF1wSxPUJ0YuJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJG01eud7SPlKsntQsGcxaR1H1LOQ4LN2oO2c59voCs=;
 b=txJ9ihdIa4mEj41EaixcPnxHG+RE6jXEwbohP15WlepEfbUx7FAW0SnTqLryD+jUOT9EGnuVO/xDzcbXwH3+iYuVfWVULMZrerP1YmOe2R3y2YZ+ie/MlZByXhjGo8BYK7k7CK3dUQ9R0YO7QjWWCsTX+YFDyA5oYT/CvbYrEaM=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by BLAPR10MB5138.namprd10.prod.outlook.com
 (2603:10b6:208:322::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 15:32:17 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::ddcf:9371:2380:d00f]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::ddcf:9371:2380:d00f%7]) with mapi id 15.20.5123.030; Mon, 4 Apr 2022
 15:32:17 +0000
Date:   Mon, 4 Apr 2022 18:31:51 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Kahurani <k.kahurani@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        phil@philpotter.co.uk, syzkaller-bugs@googlegroups.com,
        arnd@arndb.de, paskripkin@gmail.com
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Message-ID: <20220404153151.GF3293@kadam>
References: <20220404151036.265901-1-k.kahurani@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404151036.265901-1-k.kahurani@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0010.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::22)
 To CY4PR1001MB2358.namprd10.prod.outlook.com (2603:10b6:910:4a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b63c65d-d95b-4caa-d61a-08da16504cd5
X-MS-TrafficTypeDiagnostic: BLAPR10MB5138:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB51384F1CEF1A3D7BC5EED2908EE59@BLAPR10MB5138.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: svvSkzzxjJxc5oarCqYF5BoAsqMHMuaJafWiTyJzvv0zOCrK0MSjjHKL2e5KO3SJ0/fwwhVB0KwD49yrHNogB8G7mzf2HhBgTNq4HQn5KFmCe0Hj4ACD5j9c0FO2nO/TKtvl4zXnf7E5zj/yp0RshtfP2gcOzYhc4/6imK+MRNd5KGGGtOXpqOqnjf2LswVQBG+VNY2sPujgWDYLnvlMy1Gpk3Ln3eqN3naNHFkGuhwei0hpg6kQKvJ1BpluUTwAdz9m3/qt++kFB8+GrDBej90nqiiAub7fuybmm+PTQV3n+r5nO+FZ8gMeV4nzE8Y9W8wKLMhUJ9BDsWvEautblMm1Oq4YI9/4ciTpPmefDyS/vAILMvNroypOnEy0d50u3wyPhCITBRCcfy2PRwI6jqnjsFEOVGn/XYWrfmcBU6Q23LgGsVAjiYtD0Vg8IdOoK5rwCpmN40lCChlwMMvJeg6nSzvVWOeoRiMvnLNnd6gfVfzz/Mm3zubpCbF+zHK701d66ZgnOhX7atLJQf7EYM2SoR6x/5G491h3nFxGoVU/oRfkbgToQLaeYuXDzvsF6brTI0p6ma8qUSpn2ZhuK0RdqsKJpGQMTqSgQXBSBNpA/RUvF6S7TrjOJCvzhSbK9qH5elPitdkNaROG9syxIjba6qwKu2yiZVgGxU6gt42mTmPf+s4q0Pa7eMNJuPbdTFhKoDVy40f8puzntT4+mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38100700002)(38350700002)(66556008)(66476007)(8676002)(8936002)(44832011)(5660300002)(7416002)(83380400001)(66946007)(26005)(86362001)(6506007)(4326008)(6916009)(6512007)(316002)(33656002)(186003)(52116002)(33716001)(9686003)(508600001)(6486002)(1076003)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ncY0hGKqkN4Z5M9BzSOhYzONoYpzU424xtjgFY4CeK9udhxBXYLPwk3xtf62?=
 =?us-ascii?Q?VuZ0YSTrc3JHvW1X16c/VhetTJVFRs81UI4ozDRX5BuWOMdJXiuHV8rFg06w?=
 =?us-ascii?Q?iuzN+JhVQZyNLhDDWa3axt97n8DzkQPxUMeEttQtDSUWhjuO0s+7DlOYO38z?=
 =?us-ascii?Q?csKC1vU8C0MdPEeA4bMvXJlhpRo2Tj4WEi8rEwIlXtBYh6fK7KX3onMxFpiI?=
 =?us-ascii?Q?2FZVp4jOpdA2/9wMnsP8brWJMjvd7fzg5mWX/axmMoLHGY78W2YfHEBqyP5s?=
 =?us-ascii?Q?fL8kFXi7mnsC2aR8aXgqky4j6xLczDcFSfF8beSHcp2V3OdEdq2RLphwKs+e?=
 =?us-ascii?Q?BPDGfuPmGaROcOLoODJe2dimbRwLv6Bd9XY8ICcBDNDsy89Js0NPgYUovN+S?=
 =?us-ascii?Q?v6uy/CR+GMAeCDkkN4glLlNNw3tj4lgPMITB2oluzPNVhuHzdQNZ+jtyYOvI?=
 =?us-ascii?Q?Q6x93cVoiun3BHrnOJex+UTC/G33z0AqCeRnxQn7tWgF2u1oF0RAnhdvp0jI?=
 =?us-ascii?Q?oNtYe8ddKfJI64EqmeQ9w73pAnYARTYCvCvJlwd/DNA4vL3SzYyEf8JKcUxX?=
 =?us-ascii?Q?Hqb0AgACO/hOi/ah73s2t/Oox6ChMqbFhwE0PmBUr0+HT0TDg3q+d+Oobvus?=
 =?us-ascii?Q?GHQI+AVbiCizfUJqQ/UY5QTJR2Bb9crJNiiSqYAGFUo8cg2n5YSvsbbb5cxV?=
 =?us-ascii?Q?20IxSziyX8Igh16hn6fJ9MODV2OSaxOcvZbmcLr6wU11vA+FWzd1Ip5Jiv31?=
 =?us-ascii?Q?7LEkZVHaTEdw6tpgmVhlJA31O5xEIFvPaiZIC7AUxLd+SIC3BMaKOcncmMx9?=
 =?us-ascii?Q?O6EyUXaxoVkOhSroVsCe3pu0d9LToBA3ml8I0OBPLchQ/XB82Yz0t9Mj0G0O?=
 =?us-ascii?Q?xwtVqj0yOAAjqUt3R7mLsNThNL+3/u+31Pyh3XMpfb3OTSqdrpVivgA9lkMh?=
 =?us-ascii?Q?oB4NXYQJWCS49tUWd46ea3K0L6J5EhWpLztMc362E0bQ6UfcWdFNWqjey1dl?=
 =?us-ascii?Q?9bG8SAvEZNJF0+M1OdkDI94O/xggkgZGT3HO0lHLnL0gKK2OLoXcjcGqQvYy?=
 =?us-ascii?Q?2Juv3WooG5mVxzurI0UOoWhGR5x47M5FeVnqQb5lqgPDQU7rktLHUV34e/U8?=
 =?us-ascii?Q?ozFKXYqJHuR/avH8hYNYJRTMl5lfLh+iQonrDJ2mnZAfVM4trwW4UQ0sgF07?=
 =?us-ascii?Q?AigQ9yxe9cAuYRyy/YzTMjLXfSB8rL7d8tSkfG0/OkDiyZzAP/bUHSpuSBbe?=
 =?us-ascii?Q?b/4nFQshHANN/O/Z7o1PegvfowPNGX7DzcN48KsxdvfXwJc13JOKR+tHYYoR?=
 =?us-ascii?Q?xtD0CwJ+Z+V8zV7AkN3NjftR7c7OsG5jwD1VWTZJCbeMHfNleGyat+NZZ81Y?=
 =?us-ascii?Q?wdffrqbKybJegS/zJMIkS0Wfn5eAc9K9LKOsdyjKZoQFfQp/fHZpWuKuERV0?=
 =?us-ascii?Q?9SItlJ1rS48z11hS2Gn9jbeiMEe+GnlXybGzjPYC/MjKpkCO9x8C+JJHK9KF?=
 =?us-ascii?Q?wEkX7S3MlAmTPxoF5ysUAHrhaSsIUfe08fg4Ww96xLnnxtuZ4hknR4DjNrqB?=
 =?us-ascii?Q?9QWsV3pTT0nt+q5D668jgvyzz7qND2lijRaluRaHZMVdmLye8Qf5tH+MAm7d?=
 =?us-ascii?Q?ZGkMyBu833XT9b/diCRucELSwjSR7IAPCZsO0IXHIXKS46orvOiyDFlvHhLw?=
 =?us-ascii?Q?w+4ck0B2iD3mYos249asMne9SEgPduC035akRRkw4yBSMM+vtqjd4J4aHZtg?=
 =?us-ascii?Q?RokAVltio0lji+HJCw9Ki2DTOVCaBbk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b63c65d-d95b-4caa-d61a-08da16504cd5
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 15:32:17.4716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JodALE6sbgjGMzubxoYlix814gpSKYcAKhJQo/u3JsxRJUvprAcZy+tGp/09vT8b+OjqSWKkNFajIDUB6Ahq1ghT4fwUT+B61s2U9i9wywA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5138
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-04_06:2022-03-30,2022-04-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040088
X-Proofpoint-ORIG-GUID: YkhTZ-0pLdzrtrNdoymZrdDcZOvuADnl
X-Proofpoint-GUID: YkhTZ-0pLdzrtrNdoymZrdDcZOvuADnl
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
> index e2fa56b92..b5e114bed 100644
> --- a/drivers/net/usb/ax88179_178a.c
> +++ b/drivers/net/usb/ax88179_178a.c
> @@ -185,8 +185,9 @@ static const struct {
>  	{7, 0xcc, 0x4c, 0x18, 8},
>  };
>  
> -static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> -			      u16 size, void *data, int in_pm)
> +static int __must_check __ax88179_read_cmd(struct usbnet *dev, u8 cmd,
> +		                           u16 value, u16 index, u16 size,
> +					   void *data, int in_pm)
>  {
>  	int ret;
>  	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
> @@ -201,9 +202,12 @@ static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
>  	ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>  		 value, index, data, size);
>  
> -	if (unlikely(ret < 0))
> +	if (unlikely(ret < size)) {
> +		ret = ret < 0 ? ret : -ENODATA;
> +
>  		netdev_warn(dev->net, "Failed to read reg index 0x%04x: %d\n",
>  			    index, ret);
> +	}
>  
>  	return ret;

It would be better to make __ax88179_read_cmd() return 0 on success
instead of returning size on success.  Non-standard returns lead to bugs.


> @@ -1060,16 +1151,30 @@ static int ax88179_check_eeprom(struct usbnet *dev)
>  
>  		jtimeout = jiffies + delay;
>  		do {
> -			ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
> -					 1, 1, &buf);
> +		    ret = ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_CMD,
> +					   1, 1, &buf);
> +
> +		    if (ret < 0) {
> +			    netdev_dbg(dev->net,
> +				       "Failed to read SROM_CMD: %d\n",
> +			               ret);
> +			    return ret;
> +		    }
>  
>  			if (time_after(jiffies, jtimeout))
>  				return -EINVAL;

The indenting here is wrong.  Run scripts/checkpatch.pl on your patches.

regards,
dan carpenter

