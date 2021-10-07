Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DA7425478
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241700AbhJGNnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:43:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241719AbhJGNnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633614081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7yc/z+1YGWDWf2GuhIW3chj9EeE9bJXo2g7tQ+T27Cs=;
        b=XkAVkEvzDsUgoXXJfC1nAmXXyb0xkGKx3JuKIYQnb/YXDVaWyi6T61ntnp3rfypRP4QJ6n
        CdO3X4mG76tDi6tafcYRQbZOPlcF3ThgmapDphcOb8LEhvVP2FlzhkCeJIH3E1XaYgdfVN
        2QM9ht/BXsqWAxdD6HGFB6H58rZFzsk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-WO0_mr9bN1eZI379HV4OAA-1; Thu, 07 Oct 2021 09:41:04 -0400
X-MC-Unique: WO0_mr9bN1eZI379HV4OAA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75A5F84A5E1;
        Thu,  7 Oct 2021 13:41:03 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBC965D9DE;
        Thu,  7 Oct 2021 13:41:00 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v4 0/5] configure: add support for libdir and prefix option 
Date:   Thu,  7 Oct 2021 15:40:00 +0200
Message-Id: <cover.1633612111.git.aclaudi@redhat.com>
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

Patches 1-2 fix a parsing issue on current configure options, that may
trigger an endless loop when no value is provided with some options;

Patch 3 introduces support for the --opt=value style on current options,
for uniformity;

Patch 4 add the --prefix option, that may be used by some packaging
systems when calling the configure script;

Patch 5 add the --libdir option, and also drops the static LIBDIR var
from the Makefile

Changelog:
----------
v3 -> v4
  - fix parsing issue on '--include_dir' and '--libbpf_dir'
  - split '--opt value' and '--opt=value' use cases, avoid code
    duplication moving semantic checks on value to dedicated functions

v2 -> v3
  - fix parsing error on prefix and libdir options.

v1 -> v2
  - consolidate '--opt value' and '--opt=value' use cases, as suggested
    by David Ahern.
  - added patch 2 to manage the --prefix option, used by the Debian
    packaging system, as reported by Luca Boccassi, and use it when
    setting lib directory.

Andrea Claudi (5):
  configure: fix parsing issue on include_dir option
  configure: fix parsing issue on libbpf_dir option
  configure: support --param=value style
  configure: add the --prefix option
  configure: add the --libdir option

 Makefile  |  7 +++--
 configure | 85 +++++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 80 insertions(+), 12 deletions(-)

-- 
2.31.1

