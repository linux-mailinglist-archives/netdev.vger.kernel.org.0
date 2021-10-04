Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677884217EF
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhJDTw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:52:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232319AbhJDTw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 15:52:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633377067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=b9sGuR8jJFA2PalGViNI3vvdNrylXqQRpUzKJ5zMhfQ=;
        b=BPbaZei5w0jiv+aHwgl4XAhZ8Xgk96SvMKIOu6SK3SxenkOjRsM7N7uVrr0lMoeCwrpLNr
        aopCkZXIUvlCv0l/WbtaGTuUbyIObRC2+g583A/jroyDFVe3FS1QgF6EZ5EYioEurQW4Zj
        8iD6hTaQltMSPTzOUZGSAD+kzgFMdxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-yFCoa1_6NtWpoEI5FHLpFA-1; Mon, 04 Oct 2021 15:51:06 -0400
X-MC-Unique: yFCoa1_6NtWpoEI5FHLpFA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0876A8015C7;
        Mon,  4 Oct 2021 19:51:05 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.195.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3B905D9F4;
        Mon,  4 Oct 2021 19:51:02 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
Subject: [PATCH iproute2 v2 0/3] configure: add support for libdir and
Date:   Mon,  4 Oct 2021 21:50:29 +0200
Message-Id: <cover.1633369677.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add support for the libdir parameter in iproute2 configure
system. The idea is to make use of the fact that packaging systems may
assume that 'configure' comes from autotools allowing a syntax similar
to the autotools one, and using it to tell iproute2 where the distro
expects to find its lib files.

Patch 1 introduces support for the --param=value style on current
params, for uniformity.

Patch 2 add the --prefix option, that may be used by some packaging
systems when calling the configure script.

Patch 3 add the --libdir option to the configure script, and also drops
the static LIBDIR var from the Makefile.

Changelog:
----------
v1 -> v2
  - consolidate '--param value' and '--param=value' use cases, as
    suggested by David Ahern.
  - Added patch 2 to manage the --prefix option, used by the Debian
    packaging system, as reported by Luca Boccassi, and use it when
    setting lib directory.

Andrea Claudi (3):
  configure: support --param=value style
  configure: add the --prefix option
  configure: add the --libdir option

 Makefile  |  7 +++---
 configure | 72 +++++++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 66 insertions(+), 13 deletions(-)

-- 
2.31.1

