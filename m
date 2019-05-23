Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7612828BBD
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388329AbfEWUm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:42:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51132 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387722AbfEWUm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:42:57 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x4NKdvFO011983
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=iYlFozGIsl9DErC7xjhT1GGyGcAkR/5D0+S/AwNjyik=;
 b=BlD78F0lULuxohqJGDBCY1L1iaBXesVyEEiGobx4Gb2TlKzzXxVuo6Wv3xVwPildCnyC
 gZ+PPQj/S+feGHcL4jnBJQ8i8iFc9/yI71jipIl3D3CbQV4pXmLklvaCRo+/Oq4onofM
 I40AYo8j3LCjXYuR5w9xnxiiy09zi5a9oEM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2snwyh94wy-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:56 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 23 May 2019 13:42:54 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 334BA861799; Thu, 23 May 2019 13:42:50 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 12/12] bpftool: update bash-completion w/ new c option for btf dump
Date:   Thu, 23 May 2019 13:42:22 -0700
Message-ID: <20190523204222.3998365-13-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523204222.3998365-1-andriin@fb.com>
References: <20190523204222.3998365-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=889 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bash completion for new C btf dump option.

Cc: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 25 +++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 50e402a5a9c8..5b65e0309d2a 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -638,11 +638,28 @@ _bpftool()
                             esac
                             return 0
                             ;;
+                        format)
+                            COMPREPLY=( $( compgen -W "c raw" -- "$cur" ) )
+                            ;;
                         *)
-                            if [[ $cword == 6 ]] && [[ ${words[3]} == "map" ]]; then
-                                 COMPREPLY+=( $( compgen -W 'key value kv all' -- \
-                                     "$cur" ) )
-                            fi
+                            # emit extra options
+                            case ${words[3]} in
+                                id|file)
+                                    if [[ $cword > 4 ]]; then
+                                        _bpftool_once_attr 'format'
+                                    fi
+                                    ;;
+                                map|prog)
+                                    if [[ ${words[3]} == "map" ]] && [[ $cword == 6 ]]; then
+                                        COMPREPLY+=( $( compgen -W "key value kv all" -- "$cur" ) )
+                                    fi
+                                    if [[ $cword > 5 ]]; then
+                                        _bpftool_once_attr 'format'
+                                    fi
+                                    ;;
+                                *)
+                                    ;;
+                            esac
                             return 0
                             ;;
                     esac
-- 
2.17.1

