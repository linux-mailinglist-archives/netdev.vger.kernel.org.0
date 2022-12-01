Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E40063F1E5
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 14:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiLANno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 08:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiLANnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 08:43:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EBCD2FF
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 05:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669902160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=JFmfYM5LoXA563qdj8y1YLMTKUtP2pIqcacn/YOGYUU=;
        b=U9HbsnM425NA35+i5DTo5FdzpysCLbFL0SuwX3Gm8aY9hOcpsKPAyEUSeFcUg7FHvqCMjG
        pa0T+AyV6AOz47o76KwLgVF12s4f8Pb6yEiKfhe6GtlVd/z5BSd7r52MkuN/W7pc60WkBU
        uYdsZOh3Zriw9MlZiLs/f9+uOYi+gBo=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-627-MWlHWMSMPyuG2QdfQjmJ1A-1; Thu, 01 Dec 2022 08:42:39 -0500
X-MC-Unique: MWlHWMSMPyuG2QdfQjmJ1A-1
Received: by mail-pj1-f70.google.com with SMTP id n4-20020a17090a2fc400b002132adb9485so2111683pjm.0
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 05:42:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JFmfYM5LoXA563qdj8y1YLMTKUtP2pIqcacn/YOGYUU=;
        b=uYJWS6DRA0QsenLLfGf2qmAiQqpXNifybOzjNcuxTjmdRIkZoY90InV7whhEuPZg90
         9BU/z/Vj8YBQqunwPtphHR4vHOp0YVt2QSni7TWgroMiTk42QOrBFZjU/eQWdxxuUhTm
         AYpBXdg8xL9rVIyIYCrlmo+zi+mm8V4q750PSDOcTZ2YRdSnI7h2ZZ5ZtY/4Z7vik8b2
         0qE+GAjnVzm3mMVB1FWUukaI/uvWOSEbaLseOAN/AIz0Ld2NJkTuEnGsVzujOhV5jmKC
         Y9XDZTMViiUl68zv6a6U0Ux+W6oc3RHEtwmuK3QH8x02edxQRA1UJVgKOpcpg4e5Ehq3
         o9Gg==
X-Gm-Message-State: ANoB5pm8wqJDZ26MVg0k0F9IHwuqw6ucUuxOHSWvw9mQXP2+S39SoDwp
        tug7Omqegj2S+skLyvEbM9ZqYSUWC8MlRue/FT27SHl+5UfsqXhyNJ56LHROnK/wEX++nx8QegU
        z4WPn4PsPuvJFstu36U975LTv4q653vcs
X-Received: by 2002:a63:d256:0:b0:478:46b4:4f91 with SMTP id t22-20020a63d256000000b0047846b44f91mr10734504pgi.211.1669902158402;
        Thu, 01 Dec 2022 05:42:38 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7hfeI7JUFKW7r1yZwl9mS4lZxu7yY2ud+HorSjVux0lDFkOojpYVtssDT4W17zipH8gTMB1qFgxhhonWp3lEs=
X-Received: by 2002:a63:d256:0:b0:478:46b4:4f91 with SMTP id
 t22-20020a63d256000000b0047846b44f91mr10734488pgi.211.1669902158147; Thu, 01
 Dec 2022 05:42:38 -0800 (PST)
MIME-Version: 1.0
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Thu, 1 Dec 2022 14:42:27 +0100
Message-ID: <CAFqZXNs2LF-OoQBUiiSEyranJUXkPLcCfBkMkwFeM6qEwMKCTw@mail.gmail.com>
Subject: Broken SELinux/LSM labeling with MPTCP and accept(2)
To:     SElinux list <selinux@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>, mptcp@lists.linux.dev
Cc:     network dev <netdev@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Paul Moore <paul@paul-moore.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NUMERIC_HTTP_ADDR,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

As discovered by our QE, there is a problem with how the
(userspace-facing) sockets returned by accept(2) are labeled when
using MPTCP. Currently they always end up with the label representing
the kernel (typically system_u:system_r:kernel_t:s0), white they
should inherit the context from the parent socket (the one that is
passed to accept(2)).

A minimal reproducer on a Fedora/CentOS/RHEL system:

# Install dependencies
dnf install -y mptcpd nginx curl
# Disable rules that silence some SELinux denials
semodule -DB
# Set up a dummy file to be served by nginx
echo test > /usr/share/nginx/html/testfile
chmod +r /usr/share/nginx/html/testfile
# Set up nginx to use MPTCP
sysctl -w net.mptcp.enabled=1
systemctl stop nginx
mptcpize enable nginx
systemctl start nginx
# This will fail (no reply from server)
mptcpize run curl -k -o /dev/null http://127.0.0.1/testfile
# This will show the SELinux denial that caused the failure
ausearch -i -m avc | grep httpd

It is also possible to trigger the issue by running the
selinux-testsuite [1] under `mptcpize run` (it will fail on the
inet_socket test in multiple places).

Based on what I could infer from the net & mptcp code, this is roughly
how it happens (may be inaccurate or incorrect - the maze of the
networking stack is not easy to navigate for me):
1. When the server starts, the main mptcp socket is created:
   socket(2) -> ... -> socket_create() -> inet_create() ->
mptcp_init_sock() -> __mptcp_socket_create()
2. __mptcp_socket_create() calls mptcp_subflow_create_socket(), which
creates another "kern" socket, which represents the initial(?)
subflow.
3. This subflow socket goes through security_socket_post_create() ->
selinux_socket_post_create(), which gives it a kernel label based on
kern == 1, which indicates that it's a kernel-internal socket.
4. The main socket goes through its own selinux_socket_post_create(),
which gives it the label based on the current task.
5. Later, when the client connection is accepted via accept(2) on the
main socket, an underlying accept operation is performed on the
subflow socket, which is then returned directly as the result of the
accept(2) syscall.
6. Since this socket is cloned from the subflow socket, it inherits
the kernel label from the original subflow socket (via
selinux_inet_conn_request() and selinux_inet_csk_clone()).
selinux_sock_graft() then also copies the label onto the inode
representing the socket.
7. When nginx later calls writev(2) on the new socket,
selinux_file_permission() uses the inode label as the target in a
tcp_socket::write permission check. This is denied, as in the Fedora
policy httpd_t isn't allowed to write to kernel_t TCP sockets.

Side note: There is currently an odd conditional in sock_has_perm() in
security/selinux/hooks.c that skips SELinux permission checking for
sockets that have the kernel label, so native socket operations (such
as recv(2), send(2), recvmsg(2), ...) will not uncover this problem,
only generic file operations such as read(2), write(2), writev(2),
etc. I believe that check shouldn't be there, but that's for another
discussion...

So now the big question is: How to fix this? I can think of several
possible solutions, but neither of them seems to be the obvious
correct one:
1. Wrap the socket cloned from the subflow socket in another socket
(similar to how the main socket + subflow(s) are handled), which would
be cloned from the non-kern outer socket that has the right label.
This could have the disadvantage of adding unnecessary overhead, but
would probably be simpler to do.
2. Somehow ensure that the cloned socket gets the label from the main
socket instead of the subflow socket. This would probably require
adding a new LSM hook and I'm not sure at all what would be the best
way to implement this.
3. Somehow communicate the subflow socket <-> main socket relationship
to the LSM layer so that it can switch to use the label of the main
socket when handling an operation on a subflow socket (thus copying
the label correctly on accept(2)). Not a great solution, as it
requires each LSM that labels sockets to duplicate the indirection
logic.
4. Do not create the subflow sockets as "kern". (Not sure if that
would be desirable.)
5. Stop labeling kern sockets with the kernel's label on the SELinux
side and just label them based on the current task as usual. (This
would probably cause other issues, but maybe not...)

Any ideas, suggestions, or patches welcome!

[1] https://github.com/SELinuxProject/selinux-testsuite/

--
Ondrej Mosnacek
Senior Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

