Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C405049B2
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 00:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbiDQWUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 18:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiDQWUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 18:20:54 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B333311168;
        Sun, 17 Apr 2022 15:18:17 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 7D099C021; Mon, 18 Apr 2022 00:18:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650233896; bh=R+9s+6F3BACaHFBXL1V1byfLZUQtl2m1S2ZeFTjeprQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zdX+mQu14BWShbXH58oAjlf+I1q8cUZjDhWlxP3rgLOa6kb3fMdIuYpEgxZYXa1lj
         JneQ7jgjQRN1jrRG4CQbzPR3VnZXPt4Fm2kWd1Hyo/u25lDlGfYvW6NPHRcwKK7PZj
         eg/Qd744cXD1VWmwtxJiRNCNmNbkoPFi9fb8SandcdUXrhXmX+UXgqW0wLKCD/uZ+6
         cM2vu3EHeI0OfJu31pbKx7/WtSJJItUGC9nyur0UnV2tVsFE6QeXB31k20otH3PyLi
         E46cx6pZ7XWGT6cA0YTzYSs6a3wS/jp+rG08UMB8kj2N/GamAVfQcT/bPBtCAjATsO
         kRpfbSx3zhVJg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 61C07C009;
        Mon, 18 Apr 2022 00:18:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650233894; bh=R+9s+6F3BACaHFBXL1V1byfLZUQtl2m1S2ZeFTjeprQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AERIv7yvLj5DI+RoWTt4FSHIcMJVL5DgKPQQEcZmURu3tnQlBRvhJajTmVSUCjmqu
         krM9SVxJQ492j+CKF4vntq4VGFwehFtm/wTn+TBWJ18X6B8iv3Mykd9qi/JlSd17wh
         CldTzCQvcXBhp6dELMu5lxT5+Ycb44Q6fCnHplYqfmJGel7YtFhmxytUeYTjugE4Ku
         Cr/qrbg5CktegK54JLe04WLxn6PeCa2N/Uv1tA4Je0XeVqIEcZRHPaS1rTEDtnejrs
         4XI6V90ajgLapiqns6Cx2A15W6VGReDMmlM1Ijtl/TmgOfq9c+iu+z47hPOgp+q17s
         3lOic+jlEMvJw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 32b99519;
        Sun, 17 Apr 2022 22:18:08 +0000 (UTC)
Date:   Mon, 18 Apr 2022 07:17:53 +0900
From:   asmadeus@codewreck.org
To:     David Howells <dhowells@redhat.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, Greg Kurz <groug@kaod.org>
Subject: 9p EBADF with cache enabled (Was: 9p fs-cache tests/benchmark (was:
 9p fscache Duplicate cookie detected))
Message-ID: <YlySEa6QGmIHlrdG@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <2551609.RCmPuZc3Qn@silver>
 <YlwOdqVCBZKFTIfC@codewreck.org>
 <8420857.9FB56xACZ5@silver>
 <YlyFEuTY7tASl8aY@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YlyFEuTY7tASl8aY@codewreck.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(fixed the subject again and promoted David Howells to To, please read
the previous couple of mails when you have time)

asmadeus@codewreck.org wrote on Mon, Apr 18, 2022 at 06:22:26AM +0900:
> Christian Schoenebeck wrote on Sun, Apr 17, 2022 at 03:52:43PM +0200:
> > > From the looks of it, write fails in v9fs_write_begin, which itself
> > > fails because it tries to read first on a file that was open with
> > > O_WRONLY|O_CREAT|O_APPEND.
> > > Since this is an append the read is necessary to populate the local page
> > > cache when writing, and we're careful that the writeback fid is open in
> > > write, but not about read...

BTW now this is understood here's a much simpler reproducer:

---append.c----
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
	if (argc < 2)
		return 1;
	int fd = open(argv[1], O_WRONLY|O_APPEND);
	if (fd < 0)
		return 1;
	if (write(fd, "test\n", 5) < 0)
		return 1;
	return 0;
}
---

---
echo foo > foo
echo 3 > /proc/sys/vm/drop_caches
strace ./append foo
...
openat(AT_FDCWD, "foo", O_WRONLY|O_APPEND) = 3
write(3, "test\n", 5)                   = -1 EBADF (Bad file descriptor)
---

at 9p client level:
----
9pnet: (00000460) >>> TWALK fids 1,2 nwname 1d wname[0] t
9pnet: (00000460) >>> size=20 type: 110 tag: 0
9pnet: (00000460) <<< size=22 type: 111 tag: 0
9pnet: (00000460) <<< RWALK nwqid 1:
9pnet: (00000460) <<<     [0] 0.6e672b.6289a895
9pnet: (00000460) >>> TGETATTR fid 2, request_mask 6143
9pnet: (00000460) >>> size=19 type: 24 tag: 0
9pnet: (00000460) <<< size=160 type: 25 tag: 0
9pnet: (00000460) <<< RGETATTR st_result_mask=6143
<<< qid=0.6e672b.6289a895
<<< st_mode=000081ed st_nlink=1
<<< st_uid=1000 st_gid=100
<<< st_rdev=0 st_size=d538 st_blksize=126976 st_blocks=112
<<< st_atime_sec=1650233493 st_atime_nsec=697920121
<<< st_mtime_sec=1650233493 st_mtime_nsec=19911120
<<< st_ctime_sec=1650233493 st_ctime_nsec=19911120
<<< st_btime_sec=0 st_btime_nsec=0
<<< st_gen=0 st_data_version=0
9pnet: (00000460) >>> TWALK fids 2,3 nwname 0d wname[0] (null)
9pnet: (00000460) >>> size=17 type: 110 tag: 0
9pnet: (00000460) <<< size=9 type: 111 tag: 0
9pnet: (00000460) <<< RWALK nwqid 0:
9pnet: (00000460) >>> TLOPEN fid 3 mode 32768
9pnet: (00000460) >>> size=15 type: 12 tag: 0
9pnet: (00000460) <<< size=24 type: 13 tag: 0
9pnet: (00000460) <<< RLOPEN qid 0.6e672b.6289a895 iounit 1f000
9pnet: (00000460) >>> TREAD fid 3 offset 0 8192
9pnet: (00000460) >>> size=23 type: 116 tag: 0
9pnet: (00000460) <<< size=8203 type: 117 tag: 0
9pnet: (00000460) <<< RREAD count 8192
9pnet: (00000460) >>> TREAD fid 3 offset 8192 16384
9pnet: (00000460) >>> size=23 type: 116 tag: 0
9pnet: (00000460) <<< size=16395 type: 117 tag: 0
9pnet: (00000460) <<< RREAD count 16384
9pnet: (00000460) >>> TXATTRWALK file_fid 2, attr_fid 4 name security.capability
9pnet: (00000460) >>> size=36 type: 30 tag: 0
9pnet: (00000460) <<< size=11 type: 7 tag: 0
9pnet: (00000460) <<< RLERROR (-95)
9pnet: (00000460) >>> TREAD fid 3 offset 24576 30008
9pnet: (00000460) >>> size=23 type: 116 tag: 0
9pnet: (00000460) <<< size=30019 type: 117 tag: 0
9pnet: (00000460) <<< RREAD count 30008
9pnet: (00000460) >>> TWALK fids 1,4 nwname 1d wname[0] foo
9pnet: (00000460) >>> size=22 type: 110 tag: 0
9pnet: (00000460) <<< size=22 type: 111 tag: 0
9pnet: (00000460) <<< RWALK nwqid 1:
9pnet: (00000460) <<<     [0] 0.6e66f9.625c86a5
9pnet: (00000460) >>> TGETATTR fid 4, request_mask 6143
9pnet: (00000460) >>> size=19 type: 24 tag: 0
9pnet: (00000460) <<< size=160 type: 25 tag: 0
9pnet: (00000460) <<< RGETATTR st_result_mask=6143
<<< qid=0.6e66f9.625c86a5
<<< st_mode=000081a4 st_nlink=1
<<< st_uid=0 st_gid=0
<<< st_rdev=0 st_size=9 st_blksize=126976 st_blocks=8
<<< st_atime_sec=1650233249 st_atime_nsec=226674419
<<< st_mtime_sec=1650233253 st_mtime_nsec=226727529
<<< st_ctime_sec=1650233253 st_ctime_nsec=226727529
<<< st_btime_sec=0 st_btime_nsec=0
<<< st_gen=0 st_data_version=0
9pnet: (00000460) >>> TWALK fids 4,5 nwname 0d wname[0] (null)
9pnet: (00000460) >>> size=17 type: 110 tag: 0
9pnet: (00000460) <<< size=9 type: 111 tag: 0
9pnet: (00000460) <<< RWALK nwqid 0:
9pnet: (00000460) >>> TLOPEN fid 5 mode 33793
9pnet: (00000460) >>> size=15 type: 12 tag: 0
9pnet: (00000460) <<< size=24 type: 13 tag: 0
9pnet: (00000460) <<< RLOPEN qid 0.6e66f9.625c86a5 iounit 1f000
9pnet: (00000460) >>> TWALK fids 4,6 nwname 0d wname[0] (null)
9pnet: (00000460) >>> size=17 type: 110 tag: 0
9pnet: (00000460) <<< size=9 type: 111 tag: 0
9pnet: (00000460) <<< RWALK nwqid 0:
9pnet: (00000460) >>> TLOPEN fid 6 mode 2
9pnet: (00000460) >>> size=15 type: 12 tag: 0
9pnet: (00000460) <<< size=24 type: 13 tag: 0
9pnet: (00000460) <<< RLOPEN qid 0.6e66f9.625c86a5 iounit 1f000
9pnet: (00000460) >>> TXATTRWALK file_fid 4, attr_fid 7 name security.capability
9pnet: (00000460) >>> size=36 type: 30 tag: 0
9pnet: (00000460) <<< size=11 type: 7 tag: 0
9pnet: (00000460) <<< RLERROR (-95)
9pnet: (00000460) >>> TREAD fid 5 offset 0 9
9pnet: (00000460) >>> size=23 type: 116 tag: 0
9pnet: (00000460) <<< size=11 type: 7 tag: 0
9pnet: (00000460) <<< RLERROR (-9)
9pnet: (00000460) >>> TCLUNK fid 5 (try 0)
9pnet: (00000460) >>> size=11 type: 120 tag: 0
9pnet: (00000460) <<< size=7 type: 121 tag: 0
9pnet: (00000460) <<< RCLUNK fid 5
9pnet: (00000460) >>> TCLUNK fid 3 (try 0)
9pnet: (00000460) >>> size=11 type: 120 tag: 0
9pnet: (00000460) <<< size=7 type: 121 tag: 0
9pnet: (00000460) <<< RCLUNK fid 3
-------

-- 
Dominique
