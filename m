Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC52423341
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 00:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236831AbhJEWLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 18:11:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230477AbhJEWLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 18:11:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633471792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aWzcY9DwIFxWa3x0DXqWxyU6JgtlmSe1ew1aqJhLJ2o=;
        b=Gml/3y9fC2CLNbhDui1wX7cDLYcHmKitZB2dYJ1orT2loZ7a3Kj1pgHn4+Ig+NSQLM4FhZ
        0zQ5SYZXQt1+mL6AZiQ5iLLYg4Lt5RsogwiG0ZwtMUoDWrpMqQQ/0BT6jC2pGejWVMln1u
        0+an90YZK1H8ot1DTFbFkpUqUIch0PU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-BGjU8PC0PbGAPBCWuZnJCg-1; Tue, 05 Oct 2021 18:09:51 -0400
X-MC-Unique: BGjU8PC0PbGAPBCWuZnJCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C975C88C915;
        Tue,  5 Oct 2021 22:09:41 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86FCD60BD8;
        Tue,  5 Oct 2021 22:09:39 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org
Subject: [PATCH iproute2 v3 0/3] configure: add support for libdir and prefix option
Date:   Wed,  6 Oct 2021 00:08:03 +0200
Message-Id: <cover.1633455436.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
v2 -> v3
  - Fix parsing error on prefix and libdir options.

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

