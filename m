Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E806F87B1D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406985AbfHIN1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:27:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54890 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfHIN1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:27:19 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so5724697wme.4
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 06:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xDbAWdqUfFV9SlWt1VScjxm8ITThRJ1Kg5mp8bZU+mw=;
        b=SHlMGDpQlp5cCvEYOii+ur08M9LCMSP1uQIDMcctMriQHPLTyZmy1E/7Wic7Y48Qz9
         xpS4JPS5w8UbVyma3FSHXKucyFkrctQj3Qje4OBdZE4TvNJPBBGhiR/G6OQAIWhTpwvG
         rMlBFojuWXIanTiY+MK9mp0Z3QcQAG1O6I0DRkj9Qe8uHHqLgCQWhBqMAXJ3Bp5mJeFI
         V6efNqFgtZYhAk9hcf88fdhyV5wDWaHQFSV1BzHIwM7fBDDawZ5ACFJUGOP1lhTt9Ip4
         5HPNeE3h/lbB+b/VQyEX9L313MzwzcC81QhRUHwSzxTJlG9obTzSWrcJCvtkokBHy0tR
         i9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xDbAWdqUfFV9SlWt1VScjxm8ITThRJ1Kg5mp8bZU+mw=;
        b=De/SZIAdPM72VO5XPedLbF+/OVNBWm4Kebdg1/+jxx4BM9ZPHc9mSuNGShb8HHONxm
         tus/J4iVjvRcJUxkcp1Y8/wwlDtTJJecUmPOWiOhnf0u2on/JqCzzIHeSykXy6OX/zhI
         oWdlKf17Nx7fN6EPNfH9aXZBduuD3HCSFIg9YyIJl7TYvUmH6A6vE6BIJRV8RDs//ibH
         l5syvDGp4/DhSZThpcRUAMBU4mi7Qp2CZTd6rBeC+irW0GZdPNZF/BOVBHshqWaxNhzv
         bi3C/IWskjyV8zD8o1E9iaVqLgX7F2J/f2c8iW9soYyXr7vuWFzvs0pUt4fW8CMJFuMD
         Btyw==
X-Gm-Message-State: APjAAAUqIQDpqmuA3R+BW6ETtqWaOeS3XCWm+y8Mibnk+RVkr/w9VJEi
        i1dlHG1xO/0dm95EAncTzqABex4AgLg=
X-Google-Smtp-Source: APXvYqwM5b1yjjWVvRoYTWG+Yv9kf1pk7nnvqMj+91tEh60lyW6GeMdR/FH/9iwvEb3n47jPda640A==
X-Received: by 2002:a1c:d185:: with SMTP id i127mr11379962wmg.63.1565357236507;
        Fri, 09 Aug 2019 06:27:16 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f12sm108666660wrg.5.2019.08.09.06.27.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 06:27:16 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tariqt@mellanox.com, valex@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next] devlink: remove pointless data_len arg from region snapshot create
Date:   Fri,  9 Aug 2019 15:27:15 +0200
Message-Id: <20190809132715.24282-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The size of the snapshot has to be the same as the size of the region,
therefore no need to pass it again during snapshot creation. Remove the
arg and use region->size instead.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c | 7 ++-----
 include/net/devlink.h                       | 2 +-
 net/core/devlink.c                          | 9 +++------
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index 88316c743820..eaf08f7ad128 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -99,8 +99,7 @@ static void mlx4_crdump_collect_crspace(struct mlx4_dev *dev,
 					readl(cr_space + offset);
 
 		err = devlink_region_snapshot_create(crdump->region_crspace,
-						     cr_res_size, crspace_data,
-						     id, &kvfree);
+						     crspace_data, id, &kvfree);
 		if (err) {
 			kvfree(crspace_data);
 			mlx4_warn(dev, "crdump: devlink create %s snapshot id %d err %d\n",
@@ -139,9 +138,7 @@ static void mlx4_crdump_collect_fw_health(struct mlx4_dev *dev,
 					readl(health_buf_start + offset);
 
 		err = devlink_region_snapshot_create(crdump->region_fw_health,
-						     HEALTH_BUFFER_SIZE,
-						     health_data,
-						     id, &kvfree);
+						     health_data, id, &kvfree);
 		if (err) {
 			kvfree(health_data);
 			mlx4_warn(dev, "crdump: devlink create %s snapshot id %d err %d\n",
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 98b89eabd73a..c45b10d79b14 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -705,7 +705,7 @@ struct devlink_region *devlink_region_create(struct devlink *devlink,
 					     u64 region_size);
 void devlink_region_destroy(struct devlink_region *region);
 u32 devlink_region_shapshot_id_get(struct devlink *devlink);
-int devlink_region_snapshot_create(struct devlink_region *region, u64 data_len,
+int devlink_region_snapshot_create(struct devlink_region *region,
 				   u8 *data, u32 snapshot_id,
 				   devlink_snapshot_data_dest_t *data_destructor);
 int devlink_info_serial_number_put(struct devlink_info_req *req,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 57e2bcc9fe4c..95699bfb28e1 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -351,7 +351,6 @@ struct devlink_snapshot {
 	struct list_head list;
 	struct devlink_region *region;
 	devlink_snapshot_data_dest_t *data_destructor;
-	u64 data_len;
 	u8 *data;
 	u32 id;
 };
@@ -3833,8 +3832,8 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 	if (!snapshot)
 		return -EINVAL;
 
-	if (end_offset > snapshot->data_len || dump)
-		end_offset = snapshot->data_len;
+	if (end_offset > region->size || dump)
+		end_offset = region->size;
 
 	while (curr_offset < end_offset) {
 		u32 data_size;
@@ -6880,12 +6879,11 @@ EXPORT_SYMBOL_GPL(devlink_region_shapshot_id_get);
  *	The @snapshot_id should be obtained using the getter function.
  *
  *	@region: devlink region of the snapshot
- *	@data_len: size of snapshot data
  *	@data: snapshot data
  *	@snapshot_id: snapshot id to be created
  *	@data_destructor: pointer to destructor function to free data
  */
-int devlink_region_snapshot_create(struct devlink_region *region, u64 data_len,
+int devlink_region_snapshot_create(struct devlink_region *region,
 				   u8 *data, u32 snapshot_id,
 				   devlink_snapshot_data_dest_t *data_destructor)
 {
@@ -6915,7 +6913,6 @@ int devlink_region_snapshot_create(struct devlink_region *region, u64 data_len,
 	snapshot->id = snapshot_id;
 	snapshot->region = region;
 	snapshot->data = data;
-	snapshot->data_len = data_len;
 	snapshot->data_destructor = data_destructor;
 
 	list_add_tail(&snapshot->list, &region->snapshot_list);
-- 
2.21.0

