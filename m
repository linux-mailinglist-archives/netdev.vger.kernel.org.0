Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB576F04EB
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 13:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243243AbjD0LXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 07:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242993AbjD0LXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 07:23:52 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A134C00;
        Thu, 27 Apr 2023 04:23:50 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id D83BBC01F; Thu, 27 Apr 2023 13:23:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682594626; bh=jVXoVXg8/foIvtk1HSVTS9IFiWavdgfSZrmDFz15p/E=;
        h=From:Subject:Date:To:Cc:From;
        b=C7RcQrFkJ1fGRAgnpF7SCNbWDIC1DfcBggZwM+vR8fgkIlrJdfwJGYoufWtmscmi/
         eGOQVOxJa9t3cYTnKDhBbpqx5kezB7/bjkFLj12AHSENuIOfkI7thwf/V2mc9gFfTA
         mAah0+pshvxoCxKnAvX+eN8h+QDZZ95gGTv8d5EX9c2LghXdfSuNQiWD8MgYwJneVB
         tNEUJH2njMBEVD7HfDR8Ol7kREiQ9RGAUDcX3lg4C8ArMTybO5GQpAxBm4uJenWxn7
         58My583CGEuKTsZlTXPU5bi9+dLbfo5MeuCQpfckRYxokFrFB2M2Wx+wys2SLCNrbz
         3QFZwz2HSF9yg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 200E4C009;
        Thu, 27 Apr 2023 13:23:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1682594626; bh=jVXoVXg8/foIvtk1HSVTS9IFiWavdgfSZrmDFz15p/E=;
        h=From:Subject:Date:To:Cc:From;
        b=C7RcQrFkJ1fGRAgnpF7SCNbWDIC1DfcBggZwM+vR8fgkIlrJdfwJGYoufWtmscmi/
         eGOQVOxJa9t3cYTnKDhBbpqx5kezB7/bjkFLj12AHSENuIOfkI7thwf/V2mc9gFfTA
         mAah0+pshvxoCxKnAvX+eN8h+QDZZ95gGTv8d5EX9c2LghXdfSuNQiWD8MgYwJneVB
         tNEUJH2njMBEVD7HfDR8Ol7kREiQ9RGAUDcX3lg4C8ArMTybO5GQpAxBm4uJenWxn7
         58My583CGEuKTsZlTXPU5bi9+dLbfo5MeuCQpfckRYxokFrFB2M2Wx+wys2SLCNrbz
         3QFZwz2HSF9yg==
Received: from [127.0.0.2] (localhost [::1])
        by odin.codewreck.org (OpenSMTPD) with ESMTP id 380c93ba;
        Thu, 27 Apr 2023 11:23:38 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 0/5] Fix scan-build warnings
Date:   Thu, 27 Apr 2023 20:23:33 +0900
Message-Id: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADVbSmQC/x2NywrCQAwAf6XkbKDdro/6K+Ihm01tQFdJtAil/
 +7W4zAMs4CLqTicmwVMZnV9lgrdrgGeqNwENVeG0Ia+jeGIzlQwffSeMZ+GyN1h5CHuoQaJXDA
 ZFZ625EH+FtvEy2TU7/9yua7rD0ZScqp1AAAA
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     v9fs@lists.linux.dev, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Dominique Martinet <asmadeus@codewreck.org>
X-Mailer: b4 0.13-dev-f371f
X-Developer-Signature: v=1; a=openpgp-sha256; l=1398;
 i=asmadeus@codewreck.org; h=from:subject:message-id;
 bh=6PlNe9lfmPfOEWHqtma7PibG4siEPs36zdly+6bGUuk=;
 b=owEBbQKS/ZANAwAIAatOm+xqmOZwAcsmYgBkSls60h0DpmVzRXj0rpqWog9goutNMT7qXpg6E
 XpD+qzkMy6JAjMEAAEIAB0WIQT8g9txgG5a3TOhiE6rTpvsapjmcAUCZEpbOgAKCRCrTpvsapjm
 cPNyD/9Z+pd8kuYDrTSem3Amm2Dv49YbUsvjjp9jaR7c8KB2F9UIDgokCdaNp2YzBLkrHLdm8d/
 VBMPRTgwRuuSF7AFBYIaTsnagjWhMs4tPI29G1AZwZc07GeyPK+LOAX/e12B2peGqQOW5VnbzW8
 PbEvHwGXygdqMxqaSd63in8qefpsWPBzjChOMdvLNWpoIMRVjGcBhEh2P8bGBGHoTnHM+3dP6tn
 +FuM8s9Io8b4R03wMbm08LO+5NaW+mF5W7HJy+P6R8UmbgMUCTmoN2GM5aY2LUK3hI8FctPyaOK
 I0WgWne8r+rDeZk8t58pXzuKjb7b/0/XVLdWjndz/lg+ZxUWaZS+t144JqrtxIOyUusqyYEIRw9
 ymLmjfk8rvIdQiFbMrDS9b6K1MNulvogMqkM3OqMNqpnf/ox8i7AdOdbThz4KMbOgVktGTRYQFt
 p94DUtS8mqF7xoAdn6eiaHXh9IUos/rnbM7uhLyX/Wn/GT8hX6vfHG0zfQ+G9SvvYJSauUCIBm8
 qa9tlTwOehX/3OiBOUHahEToLVY5tDlJUPWBsCZ5JsqhQdfMkDirn9SDSHX2U8Xa+lV3bmrUPh6
 IDF5B3dfZ1ZRDQGwF9flc0F/gXkG6jJDHw+LVgTwhDZpGTbFCg85Bx16FDbMnhaRfb6iWDmCkoD
 hbGHJMbH8VlmApw==
X-Developer-Key: i=asmadeus@codewreck.org; a=openpgp;
 fpr=B894379F662089525B3FB1B9333F1F391BBBB00A
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I ran scan-build very crudly on our source files, and there was at least
one real bug so we might as well run it once in a while, in which case
we probably ought to also fix the less important things hence this
series.
In here the first patch is a real fix and the rest is low priority, the
last one is arguably not an improvement and can be discussed (happy to
just move the 0-initializations around to variable declaration which
would also silence scan-build afaict)

Anyway, it can probably all wait until after this merge, sorry for the
timing.

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
---
Dominique Martinet (5):
      9p: fix ignored return value in v9fs_dir_release
      9p: virtio: fix unlikely null pointer deref in handle_rerror
      9p: virtio: make sure 'offs' is initialized in zc_request
      9p: virtio: skip incrementing unused variable
      9p: remove dead stores (variable set again without being read)

 fs/9p/vfs_dir.c        |  5 +++--
 fs/9p/vfs_inode.c      |  6 ------
 fs/9p/vfs_inode_dotl.c |  1 -
 net/9p/client.c        | 46 ++++++++++++----------------------------------
 net/9p/trans_virtio.c  |  8 ++++----
 5 files changed, 19 insertions(+), 47 deletions(-)
---
base-commit: 4eb3117888a923f6b9b1ad2dd093641c49a63ae5
change-id: 20230427-scan-build-d894c16fc945

Best regards,
-- 
Dominique Martinet | Asmadeus

