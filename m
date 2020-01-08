Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73977134EF0
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgAHVel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:34:41 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:34900 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgAHVel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:34:41 -0500
Received: by mail-il1-f195.google.com with SMTP id g12so3958665ild.2;
        Wed, 08 Jan 2020 13:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=gbxm9xNOCP6X0rmH6XaI5kzfGuVUF755fNI8ps3a50M=;
        b=sgTNBvswdAoGPcYAUKwqris0PV/Y80Jb5eCTPfkO0MmMc3Pklue31Ulxy2b2r+wKxd
         qxUJ6Pfc5xsk75zgreZuM8HuMFnsR93xgr1r+w0gQHUkzYZrxrWDcM9deXT6rRL1oCaR
         Zbl16VL2nrXdbD6XGfYjgGpXC+wOyInx0cil16SiAdA6gsuqtAGbJY4AwgXvDJRYZU7N
         Rs7Og+ZlTi8Pp2Hc/vBw/nc5zgQPAMDv2edmvRfpDaEqLw/tEwdqUhaU23c4nurl9QJ3
         /EFZHB9wERcIZfuvXzLl/Ar/98wLq0jGhlvTbvcqTdkIIbSBWKQFidza5ow9VU1tjOY8
         AduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=gbxm9xNOCP6X0rmH6XaI5kzfGuVUF755fNI8ps3a50M=;
        b=EuQJKg0BgvaQmV7A/omdIfpfecZgdCRftZ7mZsDW/8Xc1k5pqNoRjwhNsMZ4F+j1vM
         j74lWI+6ewpsRC3GNzswgFa3zH3xFDwwJl2hZPUHhoFr5p/m1anJMwiO60emGYJIqMlf
         7lnL4rX5dTfr8qLfm1P0w8Zl5PRIsxCQDdenKXESkQmUMX+2TD7xp23NhCPds0QXk4xw
         bvitl/7CtB1oVW70ysnXsjH2btOs3GwHArxruYE49AL7Cqk8PCij42xR/TLRsUyiXjGE
         UCyEOeNAdXx/pJ7IygHD3skag502wIWroa9rBpwfSeoHcN3n7+HdOpAvof5LH4iID475
         h60Q==
X-Gm-Message-State: APjAAAVOZPgSJAscxEnH5mBLgpWQ3Pn8Q4AN86H5i3zrZJRMz19LWXeu
        ZDsKy485ZxcZbhftRxwFs6A=
X-Google-Smtp-Source: APXvYqxMrOQSNEQDWuPyswXEkJRRv6KqMP3MkV4aMZQ55GkEMEC63UlNi3OQBOA4kLFe/BmSTZiwZQ==
X-Received: by 2002:a92:9e99:: with SMTP id s25mr5673226ilk.80.1578519280604;
        Wed, 08 Jan 2020 13:34:40 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g23sm1337365ila.15.2020.01.08.13.34.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2020 13:34:40 -0800 (PST)
Subject: [bpf PATCH 0/2] xdp devmap improvements cleanup
From:   John Fastabend <john.fastabend@gmail.com>
To:     bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 13:34:27 -0800
Message-ID: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Couple cleanup patches to recently posted series[0] from Bjorn to
cleanup and optimize the devmap usage. Patches have commit ids
the cleanup applies to.

[0] https://www.spinics.net/lists/netdev/msg620639.html

---

John Fastabend (2):
      bpf: xdp, update devmap comments to reflect napi/rcu usage
      bpf: xdp, remove no longer required rcu_read_{un}lock()


 kernel/bpf/devmap.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--
Signature
