Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E1E24931F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 04:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgHSCz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 22:55:58 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:39748 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726632AbgHSCz5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 22:55:57 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-03 (Coremail) with SMTP id rQCowADHzhozlDxffb5EAw--.5934S2;
        Wed, 19 Aug 2020 10:53:39 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH bpf-next] libbpf: simplify the return expression of build_map_pin_path()
Date:   Wed, 19 Aug 2020 02:53:24 +0000
Message-Id: <20200819025324.14680-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowADHzhozlDxffb5EAw--.5934S2
X-Coremail-Antispam: 1UD129KBjvdXoWruF47GF4DJFy3Jr4xXr1DKFg_yoWfWFg_C3
        48XFWxGrWUGFWak3sYkrZ0vr97AFyDGr1DuF4vqrnxGFyj9ay5CrZrAFZ5JF90gw4fKF1x
        AF9avrWUZF47ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
        0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
        628vn2kIc2xKxwCY02Avz4vE14v_Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
        1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
        AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0D
        MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
        VFxhVjvjDU0xZFpf9x0JUJrcfUUUUU=
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiAwkNA13qZTxtpwAAsg
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 tools/lib/bpf/libbpf.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5d20b2da4427..cd59e237ca96 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1924,7 +1924,7 @@ static bool get_map_field_int(const char *map_name, const struct btf *btf,
 static int build_map_pin_path(struct bpf_map *map, const char *path)
 {
 	char buf[PATH_MAX];
-	int err, len;
+	int len;
 
 	if (!path)
 		path = "/sys/fs/bpf";
@@ -1935,11 +1935,7 @@ static int build_map_pin_path(struct bpf_map *map, const char *path)
 	else if (len >= PATH_MAX)
 		return -ENAMETOOLONG;
 
-	err = bpf_map__set_pin_path(map, buf);
-	if (err)
-		return err;
-
-	return 0;
+	return bpf_map__set_pin_path(map, buf);
 }
 
 
-- 
2.17.1

