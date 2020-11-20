Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C942BAF46
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgKTPq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:46:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728766AbgKTPq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 10:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605887217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=7D2x8us35q17HBLGdyACZHrbyRvTTajSnNXTqPgkdIw=;
        b=PtIW6uyXV6ZhniJ6wvoXrr9c+b+kPfPlPTafqhkiAu1nmXoZTDGELNFJbcCPVrbGoQ3oSj
        x0S076cbbiEwXcTeygt3ekqxS21yIxDa3Gli2n7KodWJ5CYUMgP+8WVrU4B0jAeG2XOFvL
        jQd+ySfeFVq8HT1ZrDqLPOCxLr62u0A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-ps29TeIDM7GoxV4gIAAiig-1; Fri, 20 Nov 2020 10:46:55 -0500
X-MC-Unique: ps29TeIDM7GoxV4gIAAiig-1
Received: by mail-wr1-f69.google.com with SMTP id 91so3503426wrk.17
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 07:46:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=7D2x8us35q17HBLGdyACZHrbyRvTTajSnNXTqPgkdIw=;
        b=h5mUHStBsJDdp42uLcSg5i0M1LhwSG1M/dRgVWCoJcPV2su4ujnnkXtZQOH6ksrjw4
         yXzp5pZQbnO7YFA9eP6W+ze86pt9Pl0H7ML7COtPKcrZEQBRt3OfXEfnZK4KTGS/2Xzp
         w+GVP4UTCidYKeilvA2s+NoGnqlCuN6C9wmElNq/0eU55jV+d2iBw6LgGp7MWP00LQRU
         pcDfW3GgPYQR7AUGAHyhFxvaZpKhUdmb63TEryStH/u1ZdMW3FW0AE3UnX1/nYhiW7BY
         Lx3F6i/hG2pqu7FQW8DaPEZKAWe+AwGVq4Xz3Sd223qHAZgFJvewWy3cNSwNNaxSSMns
         7dNw==
X-Gm-Message-State: AOAM530EtRes20/sEfdM0trR5ryZwHdr+cAWvaUzvfTQLw0pnX4SqmP+
        T4/jAOltoENzBh9vd1mfgKzAn5OkJNAIvRZwlzz2QUhSB315iHGBcAgnZNpAw+4sYst7D1QCzru
        sFvImtGy+enD1dpti
X-Received: by 2002:a1c:9d08:: with SMTP id g8mr10524669wme.171.1605887214441;
        Fri, 20 Nov 2020 07:46:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyed8fU5FpjGTbhTXESXyBAZke9Ry5lq9ggDsQOrPcdVwMvkjgsR+WMyU9nvYfHmKDmoAaxqQ==
X-Received: by 2002:a1c:9d08:: with SMTP id g8mr10524546wme.171.1605887212719;
        Fri, 20 Nov 2020 07:46:52 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a144sm4962057wmd.47.2020.11.20.07.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 07:46:52 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A19D7183852; Fri, 20 Nov 2020 16:46:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Is test_offload.py supposed to work?
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 20 Nov 2020 16:46:51 +0100
Message-ID: <87y2iwqbdg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub and Jiri

I am investigating an error with XDP offload mode, and figured I'd run
'test_offload.py' from selftests. However, I'm unable to get it to run
successfully; am I missing some config options, or has it simply
bit-rotted to the point where it no longer works?

[root@(none) bpf]# ./test_offload.py 
Test destruction of generic XDP...
Test TC non-offloaded...
Test TC non-offloaded isn't getting bound...
Test TC offloads are off by default...
FAIL: Missing or incorrect netlink extack message
  File "./test_offload.py", line 836, in <module>
    check_extack(err, "TC offload is disabled on net device.", args)
  File "./test_offload.py", line 657, in check_extack
    fail(not comp, "Missing or incorrect netlink extack message")
  File "./test_offload.py", line 86, in fail
    tb = "".join(traceback.extract_stack().format())


Commenting out that line gets me a bit further:

[root@(none) bpf]# ./test_offload.py 
Test destruction of generic XDP...
Test TC non-offloaded...
Test TC non-offloaded isn't getting bound...
Test TC offloads are off by default...
Test TC offload by default...
Test TC cBPF bytcode tries offload by default...
Test TC cBPF unbound bytecode doesn't offload...
Test non-0 chain offload...
FAIL: Missing or incorrect netlink extack message
  File "./test_offload.py", line 876, in <module>
    check_extack(err, "Driver supports only offload of chain 0.", args)
  File "./test_offload.py", line 657, in check_extack
    fail(not comp, "Missing or incorrect netlink extack message")
  File "./test_offload.py", line 86, in fail
    tb = "".join(traceback.extract_stack().format())


And again, after which I gave up:

[root@(none) bpf]# ./test_offload.py 
Test destruction of generic XDP...
Test TC non-offloaded...
Test TC non-offloaded isn't getting bound...
Test TC offloads are off by default...
Test TC offload by default...
Test TC cBPF bytcode tries offload by default...
Test TC cBPF unbound bytecode doesn't offload...
Test non-0 chain offload...
Test TC replace...
Test TC replace bad flags...
Test spurious extack from the driver...
Test TC offloads work...
FAIL: Missing or incorrect message from netdevsim in verifier log
  File "./test_offload.py", line 920, in <module>
    check_verifier_log(err, "[netdevsim] Hello from netdevsim!")
  File "./test_offload.py", line 671, in check_verifier_log
    fail(True, "Missing or incorrect message from netdevsim in verifier log")
  File "./test_offload.py", line 86, in fail
    tb = "".join(traceback.extract_stack().format())

-Toke

