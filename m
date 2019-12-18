Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32D01245C4
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfLRL24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:28:56 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45910 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726551AbfLRL24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:28:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576668535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QRJr/B2m1bfY4zcvmbafbqc9YbAmCQuMSeK/uvTtGL0=;
        b=dnH1U+rN9QFeq25IooydkuRzJKYCRsZc6hW6D7sFymDrIOvQPVmUqH56rv9C2/6fDLadWd
        anQfu3dG9ozx+IZ0Nj01ryIwwWNagAJkvD9WBa7XF93DEwEjYAzcofF6o3mm35t8UDvaYi
        U22/t1rUuy8ccN4+wQFrQHC2RhrVCLE=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-BCFFhPg3PtmcYSBTaUL-aw-1; Wed, 18 Dec 2019 06:28:51 -0500
X-MC-Unique: BCFFhPg3PtmcYSBTaUL-aw-1
Received: by mail-lj1-f200.google.com with SMTP id k21so602036ljg.3
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:28:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QRJr/B2m1bfY4zcvmbafbqc9YbAmCQuMSeK/uvTtGL0=;
        b=KTuVlGymy375GrZrLf2l9Dfcq50UTSeLh/AfOS/kvW9E+2XkwT40nuPEq0cin8+3st
         YZ1ozbZr8btBv/SSWhNUJHtT+JtcpwOxUiddSHVKVul+ZkW2zJrb8RsFuiltMG5YkHJS
         DDw1IrwpDXqVrUBo3C2DIy9fS43W3rnpeJGlmpUNis1bUDGTdxISVmIgKAuldW1Lmji3
         J10z+9MS3wIFDWLfmX311FioS2cwUXUvo+6Dm4VcGfsmoHVof2wk0LFtKRIyowWe+mss
         oG8dpjL9mx+lwE1Y9XwGcMw8wjQw1SXyFCb9/5TB5OkrxvUDlEIbmBmig00WYMCdVLi6
         jWdA==
X-Gm-Message-State: APjAAAUpQuHKdj/VidEAjdlwQUSz5qYgP4EKiyA6PTLlxQAHvMvPKilc
        o9NfUoNAnjT4774BmhJnSXf+13PoFjAYAsmVFR+3q9NH9Z9boVbcqxno15xDMu6nNQRr2rDwtky
        UrQlwKmriad0MLWFU
X-Received: by 2002:a2e:3005:: with SMTP id w5mr1406724ljw.184.1576668530191;
        Wed, 18 Dec 2019 03:28:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqxkpBeh7QUQZE6okZj6Fj+1Ja1B30srut8El8dHeCsO+xLWCsDc3RQXDsLaFhO0W4yJNgTnWw==
X-Received: by 2002:a2e:3005:: with SMTP id w5mr1406720ljw.184.1576668530046;
        Wed, 18 Dec 2019 03:28:50 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w17sm968212lfn.22.2019.12.18.03.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:28:49 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 97EAB180969; Wed, 18 Dec 2019 12:28:48 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH bpf-next] libbpf: Use PRIu64 when printing ulimit value
Date:   Wed, 18 Dec 2019 12:28:40 +0100
Message-Id: <20191218112840.871338-1-toke@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Naresh pointed out that libbpf builds fail on 32-bit architectures because
rlimit.rlim_cur is defined as 'unsigned long long' on those architectures.
Fix this by using the PRIu64 definition in printf.

Fixes: dc3a2d254782 ("libbpf: Print hint about ulimit when getting permission denied error")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3fe42d6b0c2f..ba31083998ce 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -117,7 +117,7 @@ static void pr_perm_msg(int err)
 		return;
 
 	if (limit.rlim_cur < 1024)
-		snprintf(buf, sizeof(buf), "%lu bytes", limit.rlim_cur);
+		snprintf(buf, sizeof(buf), "%"PRIu64" bytes", limit.rlim_cur);
 	else if (limit.rlim_cur < 1024*1024)
 		snprintf(buf, sizeof(buf), "%.1f KiB", (double)limit.rlim_cur / 1024);
 	else
-- 
2.24.1

