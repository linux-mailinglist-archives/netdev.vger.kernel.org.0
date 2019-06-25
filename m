Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E2F5513D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 16:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbfFYOLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 10:11:49 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35359 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbfFYOLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 10:11:49 -0400
Received: by mail-lf1-f68.google.com with SMTP id a25so12761653lfg.2
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 07:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=gYuJuPOZBk4Y/I55Xfw4nMllA34HbJMTlhwO9fs6sKE=;
        b=RrGdRYr/3/VMp2ftn6ZpAtSc6E+i+LepBHyiDnqE/7RSQxXYyCk/+3N4RfHuaFPwBu
         tIT+EtcczTiCbyoETK9FM7l3NGlIumcG6DYtRf3yuUjQSV7eqRrigrh+UhqQXjwI/r3U
         bjZLIwU1ZHKJRXRetaNlUJOVk7rWnS43NZ62J+z3IbLnaZBQBMXcMAJ4C+ju6cBs/aTM
         I9q/W4hvLc3xIQrLRpTUM7BNPSTU6K6BwCmHP3JfUAuE48Etj+TfO8o6DoYAAdGyw3v9
         ZsUT2Xxnmc7jwRXmX6+6VY8PJcUE9q5Qg696QWBZkYlRbffGARZ+SgiXI8ceAwTc78bc
         Ouzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gYuJuPOZBk4Y/I55Xfw4nMllA34HbJMTlhwO9fs6sKE=;
        b=th1D+2h9uBhRSn+Pq/huJtr+ysdkAZ6S657sAne+tpIXlnV1RU3ksv15kMFXmJ91G+
         N8ugnYIFfcjjfJhjWxjDGhMtANDHD0PAYsFCaux+02xQd6b18zvTzz0+csVF4GNxTvyf
         6KOkmS4oFpd21QThR0hB6m0SlqJ/0PBOiIFQSsJzuUrluE5squVF/E8OXHx2Kz828j2m
         0ZKeJWcgplYM2hesuTyJdHas53q0yCaLyA9o7Ffl2GxoLpzEUJxr6yFWbPto7kicvpVp
         i/zSEgEZy2RUChWHbmYjdc2Rz+LkT1P7igtMzFmrd3BUY3mkT3WomoWjHwy/HXrCzIlX
         uWaw==
X-Gm-Message-State: APjAAAXLSQJwljh4hxa3MP2nJku3kvYHnFVyUTperemCbq6BHndOt/mn
        S2UBh5RWJg8rkoZ+jIibxUdnOD0NB3w=
X-Google-Smtp-Source: APXvYqymCGzBxYFBh6NDuxj2Z0bP9KTLDNIFnB0YdKzFofu+smjIUtjZXqAQj1DCj8d9p2R1wtj91w==
X-Received: by 2002:ac2:4901:: with SMTP id n1mr2442751lfi.153.1561471906859;
        Tue, 25 Jun 2019 07:11:46 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id z12sm1971522lfg.67.2019.06.25.07.11.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:11:46 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH net-next] tools: lib: bpf: libbpf: fix max() type mistmatch for 32bit
Date:   Tue, 25 Jun 2019 17:11:42 +0300
Message-Id: <20190625141142.2378-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It fixes build error for 32bit coused by type mistmatch
size_t/unsigned long.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

Based on net-next/master

 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4259c9f0cfe7..d03016a559e2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -778,7 +778,7 @@ static struct bpf_map *bpf_object__add_map(struct bpf_object *obj)
 	if (obj->nr_maps < obj->maps_cap)
 		return &obj->maps[obj->nr_maps++];
 
-	new_cap = max(4ul, obj->maps_cap * 3 / 2);
+	new_cap = max((size_t)4, obj->maps_cap * 3 / 2);
 	new_maps = realloc(obj->maps, new_cap * sizeof(*obj->maps));
 	if (!new_maps) {
 		pr_warning("alloc maps for object failed\n");
-- 
2.17.1

