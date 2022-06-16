Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA33F54EEBA
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 03:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379226AbiFQBW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 21:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiFQBW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 21:22:57 -0400
X-Greylist: delayed 5119 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Jun 2022 18:22:56 PDT
Received: from mx0b-00256a01.pphosted.com (mx0b-00256a01.pphosted.com [67.231.153.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67AE13D40
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 18:22:56 -0700 (PDT)
Received: from pps.filterd (m0144081.ppops.net [127.0.0.1])
        by mx0b-00256a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GMfh2f021148
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 19:57:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nyu.edu; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding;
 s=20180315; bh=6Lj/b/Ck9Lgr+yfmtdvmYSoOr5YdarF+fBSEOgcV8UI=;
 b=IsE6tA09aXAbvDJcXfEY7CN7JjMFQLTQJr7phlBx62znQ73pepU7iTrgVEtJdXcLHZtW
 n620ocYMXexi+r+utLNvfTONNBXNYCrVfeoAkzrYsUUeDKnWhwlEAOv9m5kqjoeJ9O53
 me2zK93kMSWQIyxu1QzyCUJthTE0AnI67KZ0kcTFpfUVjptMr/5ST3JgFvnzeXzP+Nen
 fwx7KpFeTXigYYnYVWLl5nTs3yDyuUUpUlwKSToRE1xj4cujJl3rXRb3azLkhAcJVJqL
 WxMc9RgYxYKYEAV1KV0jrW/VwEGng4D4osGqi6vDM/wxLA0LwseP0OqKUjyBt+yYhlAl zQ== 
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
        by mx0b-00256a01.pphosted.com (PPS) with ESMTPS id 3grapavs8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 19:57:36 -0400
Received: by mail-qv1-f69.google.com with SMTP id c4-20020a0cca04000000b0046e6864aca4so3061737qvk.18
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 16:57:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Lj/b/Ck9Lgr+yfmtdvmYSoOr5YdarF+fBSEOgcV8UI=;
        b=y2Fqh9hy36QsGzvWhLDtLPrsqqDCYbUHlS1AoUTppghz2Taz2x3WAV8eHTtn2a4J9x
         3ePlw5HqpQpr1E35Yzcd+vsauI1O9mdKn9+v2Lyd11AUNBYu42DpKV4lbTQA7fk70wbO
         22G+oY2/LB5nirUh7vLkQx/WbcgrLas8NyGtuVFrdbZw3gd4fiZLyGE7nMzjEANcZwSO
         D01sVO2LZjMh+B/ghq8r/Puc+lYikeIyE1xQVdGPgxLTL7Dk8JrHmyihoFdbmaT536Zn
         p0DBcRgcqS3zkVDY4y0keLwh/FDXgLCMQ2n8ac9SWUYyMOV0coa0Prs1UeqPs7nXPfgw
         ZGAg==
X-Gm-Message-State: AJIora+5p7sxlof2KmXUBa2YhcmzEXEp8uCcAREsfSH3a1S/1p4PA4hM
        xfE11CFyz8ikmuotohZ0HWw86U8wQzj1k/H6Wbw4sppmJYC9R2iVnmpB6o+moqfOIhL0j1CasDK
        E7sgMs1mzucJtn9I=
X-Received: by 2002:ac8:5e4e:0:b0:306:773f:b747 with SMTP id i14-20020ac85e4e000000b00306773fb747mr6197108qtx.499.1655423855993;
        Thu, 16 Jun 2022 16:57:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ugQ99UVhvoXNxKhaNOanvgu07mdg5MuXMfAD5gxXqaKoABzuYxwMHKGYnFMZAi70lZzq//2g==
X-Received: by 2002:ac8:5e4e:0:b0:306:773f:b747 with SMTP id i14-20020ac85e4e000000b00306773fb747mr6197099qtx.499.1655423855788;
        Thu, 16 Jun 2022 16:57:35 -0700 (PDT)
Received: from localhost.localdomain (cpe-66-65-49-54.nyc.res.rr.com. [66.65.49.54])
        by smtp.gmail.com with ESMTPSA id y17-20020a37f611000000b006a69f6793c5sm2714008qkj.14.2022.06.16.16.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 16:57:35 -0700 (PDT)
From:   HighW4y2H3ll <huzh@nyu.edu>
To:     netdev@vger.kernel.org
Cc:     HighW4y2H3ll <huzh@nyu.edu>
Subject: [PATCH] Fix Fortify String build warnings caused by the memcpy check in hinic_devlink.c.
Date:   Thu, 16 Jun 2022 19:57:27 -0400
Message-Id: <20220616235727.36546-1-huzh@nyu.edu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: mzCHzYhOoPvWjrCMRRakWwqiAUVxIcFy
X-Proofpoint-ORIG-GUID: mzCHzYhOoPvWjrCMRRakWwqiAUVxIcFy
X-Orig-IP: 209.85.219.69
X-Proofpoint-Spam-Details: rule=outbound_bp_notspam policy=outbound_bp score=0 priorityscore=1501
 clxscore=1011 mlxscore=0 suspectscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=935 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160097
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

...
	memcpy(&host_image->image_section_info[i],
	       	&fw_image->fw_section_info[i],
	       	sizeof(struct fw_section_info_st));
...
---
 drivers/net/ethernet/huawei/hinic/hinic_devlink.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.h b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
index 46760d607b9b..d7b26830c9ee 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.h
@@ -92,14 +92,20 @@ struct fw_image_st {
 		u32 fw_section_cnt:16;
 		u32 resd:16;
 	} fw_info;
-	struct fw_section_info_st fw_section_info[MAX_FW_TYPE_NUM];
+	union {
+	struct_group(info, fw_section_info_st fw_section_info[0];);
+	struct fw_section_info_st __data[MAX_FW_TYPE_NUM];
+	};
 	u32 device_id;
 	u32 res[101];
 	void *bin_data;
 };
 
 struct host_image_st {
-	struct fw_section_info_st image_section_info[MAX_FW_TYPE_NUM];
+	union {
+	struct_group(info, fw_section_info_st image_section_info[0];);
+	struct fw_section_info_st __data[MAX_FW_TYPE_NUM];
+	};
 	struct {
 		u32 up_total_len;
 		u32 fw_version;
-- 
2.35.1

